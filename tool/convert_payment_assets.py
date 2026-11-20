"""Convert the supplied payment artwork to pixel-identical, full-resolution WebP."""
import json
import sys
from pathlib import Path
from PIL import Image

source = Path(sys.argv[1])
gcash_source = Path(sys.argv[2]) if len(sys.argv) > 2 else source
target = Path(__file__).resolve().parents[1] / 'assets/images'
slots = {
 'gcash': [4899258,4899259,4899260,4899261,4899262],
 'paypal': [4899187,4899192,4899189,4899101,4899216],
 'cashapp':[4899188,4899193,4899194,4899217,4899220],
 'pix':[4899185,4899190,4899195,4899218,4899221],
 'pagbank':[4899186,4899191,4899196,4899219,4899222],
 'gopay':[4899223,4899224,4899225,4899244,4899251],
 'ovo':[4899226,4899227,4899238,4899245,4899252],
 'maya':[4899228,4899229,4899239,4899246,4899253],
 'mercado':[4899230,4899231,4899240,4899247,4899254],
 'payoneer':[4899232,4899233,4899241,4899248,4899255],
 'sbp':[4899234,4899235,4899242,4899249,4899256],
 'yoomoney':[4899236,4899237,4899243,4899250,4899257],
}
manifest=[]
for name,ids in slots.items():
 for variant,number in zip(['normal','selected','card','badge','small'],ids):
  original=(gcash_source if name == 'gcash' else source)/f'Group {number}.png'; output=target/f'ps_payment_{name}_{variant}.webp'
  with Image.open(original) as image:
   image=image.convert('RGBA'); image.save(output,'WEBP',lossless=True,quality=100,method=6,exact=True)
   with Image.open(output) as decoded:
    assert image.size==decoded.size and image.tobytes()==decoded.convert('RGBA').tobytes(),original
  manifest.append({'source':original.name,'asset':output.name,'width':image.width,'height':image.height,'pngBytes':original.stat().st_size,'webpBytes':output.stat().st_size})
Path(__file__).with_name('payment_assets.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(f"Verified {len(manifest)} lossless assets; PNG {sum(a['pngBytes'] for a in manifest)} bytes -> WebP {sum(a['webpBytes'] for a in manifest)} bytes")
