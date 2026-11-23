"""Build review galleries from the Flutter layout renders (requires Pillow)."""

import html
import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

root = Path(__file__).resolve().parents[1]
output = root / 'artifacts/localization'
qa = root / 'artifacts/qa'
profiles = {
    'US': '英语兜底', 'ID': '印度尼西亚', 'PH': '菲律宾', 'BR': '巴西',
    'MX': '墨西哥', 'JP': '日本', 'AR': '阿根廷', 'RU': '俄罗斯',
    'DE': '德国', 'FR': '法国',
}
representatives = {'home': '首页', 'page': '提现页', 'dialog': '提现弹窗'}
style = '''body{font:16px system-ui;background:#edf2f8;color:#17213a;margin:24px}
h1{font-size:26px}nav{display:flex;flex-wrap:wrap;gap:10px;position:sticky;top:0;padding:8px 0;background:#edf2f8;z-index:2}
label{display:flex;align-items:center;gap:5px}select{padding:8px;font:inherit}
section{margin:24px 0}section[hidden],article[hidden]{display:none}
article{display:inline-flex;flex-direction:column;vertical-align:top;margin:6px;background:white;padding:10px;border-radius:12px;box-shadow:0 2px 12px #2233;width:min(100%,280px)}
img{display:block;width:100%;height:auto;border-radius:8px}a{color:#164e9c}
p{max-width:920px;line-height:1.65}small{min-height:2.5em;display:block}.qa article{width:min(100%,188px)}
'''
language_names = {
    'launch': '启动页', 'home': '首页', 'quiz': '答题页', 'wheel': '转盘页',
    'cash': '提现页', 'legacy_home': '旧版首页', 'legacy_quiz': '旧版答题页',
    'legacy_wheel': '旧版转盘页', 'web_privacy': '隐私政策页栏',
    'web_game': '小游戏页栏', 'web_gameplay': '玩法页栏', 'in_app_notice': '应用内通知',
    'confirm_information': '已保存长账号确认', 'about_payout': '提现说明',
    'about_saved_payout': '已有账号的提现说明', 'payout_form': '提现表单',
    'payout_form_keyboard': '提现表单 · 键盘展开', 'payout_form_pagbank': 'PagBank 提现表单',
    'quiz_rank_1': '答题进度弹窗', 'quiz_rank_2': '答题排行弹窗',
    'confirmed': '收款资料确认完成', 'confirm_2': '提现确认提示',
    'not_enough': '余额不足', 'queue': '提现排队', 'gold_unlocked': '解锁金猪',
    'diamond_unlocked': '解锁钻石猪', 'review': '提现审核中', 'review_failed': '提现审核失败',
    'diamond_reward': '钻石奖励', 'more_chances': '更多机会',
    'wheel_reward': '转盘奖励', 'bubble_reward': '气泡奖励', 'wheel_empty': '转盘次数用完',
    'pig_story_false': '猪池故事 · 粉猪', 'pig_story_true': '猪池故事 · 金猪',
    'get_award': '领取成长奖励', 'tip_adLoadfaild': '广告加载失败',
    'tip_notWifi': '网络异常', 'tip_adLimit': '广告次数限制',
    'tip_noticeOpen': '开启通知提示', 'tip_notWheel': '转盘未解锁',
    'award_quiz': '答题领取奖励', 'award_wheel': '转盘领取奖励',
    'award_other': '领取奖励', 'award_apple': '喂食奖励', 'award_buble': '气泡领取奖励',
    'guide_1': '引导 1 · 余额', 'guide_2': '引导 2 · 观看广告',
    'guide_3': '引导 3 · 选择奖励', 'guide_4': '引导 4 · 第一段剧情',
    'guide_4_second': '引导 4 · 第二段剧情', 'guide_5': '引导 5 · 喂苹果',
    'guide_6': '引导 6 · 金猪升级', 'guide_6_large_balance': '引导 6 · 较大金额',
    'guide_7': '引导 7 · 首笔奖励',
    'guide_8': '引导 8 · 答题', 'guide_9': '引导 9 · 提现步骤',
    'guide_10': '引导 10 · 收款表单', 'guide_10_keyboard': '引导 10 · 键盘展开',
    'guide_11': '引导 11 · 官方通知', 'guide_12_false': '成长奖励 · 新用户',
    'guide_12_true': '成长奖励 · 老用户', 'guide_12_denied_false': '成长奖励 · 新用户，通知关闭',
    'guide_12_denied_true': '成长奖励 · 老用户，通知关闭', 'guide_13': '引导 13 · 底栏转盘',
}


def title(view):
    if '_level' in view:
        base, level = view.split('_level')
        return f'{language_names[base]} · {"金猪" if level == "1" else "钻石猪"}'
    if view.startswith('onboarding_'):
        return f'旧版引导 {view[-1]}'
    if view.startswith('last_task_'):
        index = int(view.split('_')[-1])
        return f'提现任务 {1 + index // 3} · {("答题", "转盘", "广告")[index % 3]}'
    return language_names.get(view, view)


def heading(text, css_class=''):
    return [
        '<!doctype html><html lang="zh-CN"><meta charset="utf-8">',
        '<meta name="viewport" content="width=device-width,initial-scale=1">',
        f'<title>C152 B · {text}</title><style>{style}</style>',
        f'<body class="{css_class}"><h1>C152 B · {text}</h1>',
    ]


def selector(field, label, options, selected=None):
    choices = ''.join(
        f'<option value="{html.escape(value)}"'
        f'{" selected" if value == selected else ""}>{html.escape(name)}</option>'
        for value, name in options
    )
    return f'<label>{label}<select id="{field}">{choices}</select></label>'


script = '''<script>
const controls = [...document.querySelectorAll("nav select")];
function filter() {
  document.querySelectorAll("section").forEach(section => {
    for (const card of section.querySelectorAll("article")) {
      card.hidden = controls.some(select =>
        select.value !== "all" &&
        (card.dataset[select.id] || section.dataset[select.id]) !== select.value);
    }
    section.hidden = !section.querySelector("article:not([hidden])");
  });
}
controls.forEach(select => select.onchange = filter);
filter();
</script>'''
countries = [('all', '全部地区'), *[(code, f'{name} · {code}') for code, name in profiles.items()]]


def card(file, caption, *, view='', size=''):
    title_text = html.escape(caption)
    return (
        f'<article data-view="{view}" data-size="{size}"><small>{title_text}</small>'
        f'<a href="{file}"><img loading="lazy" src="{file}" alt="{title_text}"></a></article>'
    )


if all((output / f'{code}_{view}.png').is_file() for code in profiles for view in representatives):
    font_path = Path('/System/Library/Fonts/Hiragino Sans GB.ttc')
    font = ImageFont.truetype(str(font_path), 21) if font_path.exists() else ImageFont.load_default()
    for view in representatives:
        width, height, gap, label = 225, 487, 12, 38
        sheet = Image.new('RGB', (width * 5 + gap * 6, (height + label) * 2 + gap * 3), '#eaf0f8')
        draw = ImageDraw.Draw(sheet)
        for i, (code, name) in enumerate(profiles.items()):
            x = gap + (i % 5) * (width + gap)
            y = gap + (i // 5) * (height + label + gap)
            draw.text((x, y + 5), f'{name} · {code}', font=font, fill='#18233a')
            with Image.open(output / f'{code}_{view}.png') as image:
                image.thumbnail((width, height), Image.Resampling.LANCZOS)
                sheet.paste(image, (x, y + label))
        sheet.save(output / f'{view}_overview.png')
    parts = heading('各地区代表画面')
    parts += [
        '<p>各地区各有一张首页、提现页和提现弹窗。点击放大。按 375×812 的逻辑画面以两倍像素导出。</p>',
        '<p><a href="../qa/index.html">完整页面、弹窗及状态预览</a></p>',
        '<nav>' + selector('country', '地区', countries) + '</nav>',
    ]
    for code, name in profiles.items():
        parts.append(f'<section data-country="{code}"><h2>{name} · {code}</h2>')
        parts.extend(card(f'{code}_{view}.png', label) for view, label in representatives.items())
        parts.append('</section>')
    (output / 'index.html').write_text('\n'.join([*parts, script, '</body></html>']), encoding='utf-8')

results = json.loads((qa / 'results.json').read_text(encoding='utf-8'))
checked = results['checked']
sizes = list(dict.fromkeys(row['size'] for row in checked))
views = list(dict.fromkeys(row['view'] for row in checked))
images = [row for row in checked if row.get('image') and (qa / row['image']).is_file()]
parts = heading('页面、弹窗及状态检查', 'qa')
parts += [
    f'<p>覆盖 {len(views)} 种 Flutter 页面和状态、{len({r["country"] for r in checked})} 个地区配置及 '
    f'{len(sizes)} 种尺寸，共 {len(checked)} 个组合。下方可查看 {len(images)} 张代表渲染图。'
    '网页示例仅显示应用内标题和安全区。键盘示例保留系统键盘占位。</p>',
    '<p><a href="results.json">检查数据</a>'
    + (' · <a href="../localization/index.html">各地区首页及提现高清图</a>' if (output / 'index.html').is_file() else '')
    + '</p>',
    '<nav>' + selector('country', '地区', countries, 'US')
    + selector('view', '页面', [('all', '全部页面'), *((view, title(view)) for view in views)])
    + selector('size', '尺寸', [('all', '全部截图尺寸'), *((size, size) for size in sizes if any(r['size'] == size for r in images))], '375x812')
    + '</nav>',
]
for code, name in profiles.items():
    parts.append(f'<section data-country="{code}"><h2>{name} · {code}</h2>')
    parts.extend(
        card(row['image'], title(row['view']), view=row['view'], size=row['size'])
        for row in images if row['country'] == code
    )
    parts.append('</section>')
(qa / 'index.html').write_text('\n'.join([*parts, script, '</body></html>']), encoding='utf-8')
print(qa / 'index.html')
