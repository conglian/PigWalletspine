"""Run the complete Flutter layout matrix, including the existing Spine animations.

Usage: python3 tool/run_localization_qa.py /absolute/path/to/flutter
The temporary native framework is built from the resolved Spine dependency.
"""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
from urllib.parse import unquote, urlparse

root = Path(__file__).resolve().parents[1]
flutter = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(shutil.which('flutter') or '')
if not flutter.is_file():
    raise SystemExit('Pass the Flutter executable as the first argument.')
if sys.platform != 'darwin':
    raise SystemExit('This native rendering helper currently runs on macOS.')
config = json.loads((root / '.dart_tool/package_config.json').read_text())
package = next(p for p in config['packages'] if p['name'] == 'spine_flutter')
uri = urlparse(package['rootUri'])
dependency = Path(unquote(uri.path)) if uri.scheme == 'file' else (root / '.dart_tool' / package['rootUri']).resolve()
framework = root / '.dart_tool/localization_native/spine_flutter.framework'
framework.mkdir(parents=True, exist_ok=True)
binary = framework / 'spine_flutter'
if not binary.exists():
    tester = flutter.resolve().parents[1] / 'bin/cache/artifacts/engine/darwin-x64/flutter_tester'
    architecture = 'arm64' if 'arm64' in subprocess.check_output(['file', str(tester)], text=True) else 'x86_64'
    classes = dependency / 'macos/Classes'
    sources = [*sorted((classes / 'spine-cpp/src/spine').glob('*.cpp')), classes / 'spine_flutter.cpp']
    subprocess.run(['clang++', '-arch', architecture, '-dynamiclib', '-std=c++11', '-O1', '-I' + str(classes / 'spine-cpp/include'), '-I' + str(dependency / 'src/spine-cpp-lite'), *map(str, sources), '-o', str(binary)], check=True)
link = root / 'spine_flutter.framework'
if link.exists() or link.is_symlink():
    raise SystemExit('Remove or move the existing spine_flutter.framework before running this helper.')
link.symlink_to(framework)
try:
    raise SystemExit(subprocess.run([str(flutter.resolve()), 'test', 'tool/check_all_localized_views_test.dart', '--no-pub'], cwd=root).returncode)
finally:
    if link.is_symlink() and link.resolve() == framework:
        link.unlink()
