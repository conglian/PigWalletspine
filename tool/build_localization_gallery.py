"""Build review galleries from real Flutter renders (requires Pillow)."""
import html
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

root = Path(__file__).resolve().parents[1]
output = root / 'artifacts/localization'
profiles = [('US', '英语兜底'), ('ID', '印度尼西亚'), ('PH', '菲律宾'), ('BR', '巴西'), ('MX', '墨西哥'), ('JP', '日本'), ('AR', '阿根廷'), ('RU', '俄罗斯'), ('DE', '德国'), ('FR', '法国')]
font_path = Path('/System/Library/Fonts/Hiragino Sans GB.ttc')
font = ImageFont.truetype(str(font_path), 21) if font_path.exists() else ImageFont.load_default()
for kind, title in [('home', '首页'), ('page', '提现页'), ('dialog', '弹窗')]:
    width, height, gap, label = 225, 487, 12, 38
    sheet = Image.new('RGB', (width * 5 + gap * 6, (height + label) * 2 + gap * 3), '#eaf0f8')
    draw = ImageDraw.Draw(sheet)
    for i, (code, name) in enumerate(profiles):
        x, y = gap + (i % 5) * (width + gap), gap + (i // 5) * (height + label + gap)
        draw.text((x, y + 5), f'{name} · {code}', font=font, fill='#18233a')
        image = Image.open(output / f'{code}_{kind}.png').convert('RGB')
        image.thumbnail((width, height), Image.Resampling.LANCZOS)
        sheet.paste(image, (x, y + label))
    sheet.save(output / f'{kind}_overview.png')

style = '''body{font:16px system-ui;background:#edf2f8;color:#17213a;margin:24px}h1{font-size:26px}select{padding:10px;font-size:16px;position:sticky;top:12px;z-index:2}section{margin:28px 0}article{display:inline-block;vertical-align:top;margin:8px;background:white;padding:12px;border-radius:14px;box-shadow:0 3px 16px #2333}img{display:block;width:min(100%,300px);height:auto;border-radius:8px}a{color:#164e9c}p{max-width:1000px;line-height:1.7}small{display:block;margin-bottom:8px}section[hidden]{display:none}.qa img{width:180px}.qa article{width:180px}'''
selector = '<select id="country"><option value="all">全部国家</option>' + ''.join(f'<option value="{code}">{name} · {code}</option>' for code, name in profiles) + '</select>'
script = '''<script>document.querySelector('#country').onchange=e=>document.querySelectorAll('section').forEach(s=>s.hidden=e.target.value!=='all'&&s.dataset.country!==e.target.value)</script>'''
parts = ['<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>C152 B 本地化预览</title>', f'<style>{style}</style><h1>C152 B · 各国家页面预览</h1>', '<p>实际 Flutter 代码渲染：每个国家包含首页、提现页和一个提现弹窗。统一示例余额为基础金额 12.75 USD，按需求文档中的固定业务系数显示当地金额。画布为 375×812，导出图为 750×1624；点击图片查看原图。此处为渲染预览，非真机截图。</p>', selector]
for code, name in profiles:
    parts.append(f'<section data-country="{code}"><h2>{name} · {code}</h2>')
    for kind, title in [('home', '首页'), ('page', '提现页'), ('dialog', '提现弹窗')]:
        file = f'{code}_{kind}.png'
        parts.append(f'<article><small>{title}</small><a href="{file}"><img loading="lazy" src="{file}" alt="{name}{title}"></a></article>')
    parts.append('</section>')
parts += ['<p><a href="../qa/index.html">查看完整页面、弹窗和状态清单</a></p>', script, '</html>']
(output / 'index.html').write_text('\n'.join(parts))
qa = root / 'artifacts/qa'
parts = ['<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>C152 B 页面检查</title>', f'<style>{style}</style><body class="qa"><h1>C152 B · 完整页面及状态检查</h1>', '<p>67 种页面、弹窗和状态，覆盖 9 个需求国家及英语兜底。布局检查尺寸为 320×568、375×812、768×1024；此页保存 375×812 的检查渲染帧。部分引导、列表和奖励动画展示中间帧，正式交付预览见上方入口。</p><p><a href="../localization/index.html">各国家首页、提现页与弹窗高清预览</a> · <a href="results.json">自动布局检查结果</a></p>', selector]
for code, name in profiles:
    files = sorted(qa.glob(f'{code}_*.png'))
    parts.append(f'<section data-country="{code}"><h2>{name} · {code}</h2>')
    for file in files:
        label = html.escape(file.stem.removeprefix(code + '_'))
        parts.append(f'<article><small>{label}</small><a href="{file.name}"><img loading="lazy" src="{file.name}" alt="{label}"></a></article>')
    parts.append('</section>')
parts += [script, '</body></html>']
(qa / 'index.html').write_text('\n'.join(parts))
print('Generated localization/index.html and qa/index.html')
