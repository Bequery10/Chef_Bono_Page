$file = "c:\Users\ereng\Desktop\Chef_Bono_Page\index.html"
$content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

# 1. Accent colors: amber -> mint green (CSS variables only)
$content = $content -replace '--fire: #E8763A;', '--fire: #2BB58A;'
$content = $content -replace '--fire2: #F0A060;', '--fire2: #40CFA0;'
$content = $content -replace '--fire3: #FAC890;', '--fire3: #8EEAC8;'
$content = $content -replace '--fire-dim: rgba\(232, 118, 58, \.12\);', '--fire-dim: rgba(43, 181, 138, .12);'
$content = $content -replace '--glass-border: rgba\(200, 208, 232, \.08\);', '--glass-border: rgba(43, 181, 138, .15);'
$content = $content -replace '--glass-shine: rgba\(200, 208, 232, \.04\);', '--glass-shine: rgba(43, 181, 138, .06);'

# 2. All hardcoded amber rgba -> mint rgba
$content = $content -replace 'rgba\(232, 118, 58', 'rgba(43, 181, 138'

# 3. Hero image - use food/cooking unsplash image  
$content = $content -replace "url\('hero_kitchen\.png'\)", "url('https://images.unsplash.com/photo-1495521821757-a1efb6729352?w=2000&q=85')"

# 4. Cinematic image - modern kitchen unsplash
$content = $content -replace "url\('cin_kitchen\.png'\)", "url('https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=1200&q=85')"

# 5. Stats: 10000 -> 20000, 8 -> 9 diet categories
$content = $content -replace 'data-count="10000"', 'data-count="20000"'
$content = $content -replace 'data-count="8"', 'data-count="9"'

# 6. Add tooltip to diet categories stat cell
$content = $content -replace '<div class="stat-cell">\s*<div class="stat-n" data-count="9">0</div>\s*<div class="stat-l">Diet Categories</div>\s*</div>', '<div class="stat-cell tooltip-host" data-tooltip="Vegan, Vegetarian, Gluten-Free, Keto, Paleo, Pescatarian, Low-Carb, Dairy-Free, Mediterranean"><div class="stat-n" data-count="9">0</div><div class="stat-l" style="border-bottom:1px dashed var(--muted);cursor:help;padding-bottom:2px">Diet Categories</div></div>'

# 7. Make doc cards into <a> links
$content = $content -replace "const el = document\.createElement\('div'\);", "const el = document.createElement('a');"
$content = $content -replace "el\.className = 'doc-card';", "el.className = 'doc-card';`n      el.href = d.file;`n      el.target = '_blank';`n      el.rel = 'noopener';"

# 8. Team section - replace grid with film strip
$teamOld = @"
    <div class="team-grid rev">
      <div class="team-card">
        <div class="team-card-line"></div>
        <div class="team-idx">01</div>
        <div class="team-name">Yelda S`u{0131}la<br />Mumcu</div>
        <div class="team-role">Team Member</div>
        <div class="team-bg-num">I</div>
      </div>
      <div class="team-card">
        <div class="team-card-line"></div>
        <div class="team-idx">02</div>
        <div class="team-name">Berkan<br />G`u{00f6}kg`u{00f6}z</div>
        <div class="team-role">Team Member</div>
        <div class="team-bg-num">II</div>
      </div>
      <div class="team-card">
        <div class="team-card-line"></div>
        <div class="team-idx">03</div>
        <div class="team-name">Buse<br />`u{015e}ahin</div>
        <div class="team-role">Team Member</div>
        <div class="team-bg-num">III</div>
      </div>
      <div class="team-card">
        <div class="team-card-line"></div>
        <div class="team-idx">04</div>
        <div class="team-name">Eren<br />Serdar</div>
        <div class="team-role">Team Member</div>
        <div class="team-bg-num">IV</div>
      </div>
    </div>
"@

$f1 = '<div class="film-frame"><div class="f-num">01</div><div class="f-init">YS</div><div class="f-name">Yelda S' + [char]0x131 + 'la<br/>Mumcu</div><div class="f-role">Team Member</div></div>'
$f2 = '<div class="film-frame"><div class="f-num">02</div><div class="f-init">BG</div><div class="f-name">Berkan<br/>G' + [char]0xF6 + 'kg' + [char]0xF6 + 'z</div><div class="f-role">Team Member</div></div>'
$f3 = '<div class="film-frame"><div class="f-num">03</div><div class="f-init">B' + [char]0x15E + '</div><div class="f-name">Buse<br/>' + [char]0x15E + 'ahin</div><div class="f-role">Team Member</div></div>'
$f4 = '<div class="film-frame"><div class="f-num">04</div><div class="f-init">ES</div><div class="f-name">Eren<br/>Serdar</div><div class="f-role">Team Member</div></div>'

$filmSet = "$f1`n        $f2`n        $f3`n        $f4"

$teamNew = @"
    <div class="team-strip-wrap">
      <div class="film-track" id="filmTrack">
        $filmSet
        $filmSet
        $filmSet
        $filmSet
      </div>
    </div>
"@

$content = $content.Replace($teamOld.Trim(), $teamNew.Trim())

# 9. Team CSS: replace grid with film strip
$teamCssOld = '/* ' + [char]0x2500 + [char]0x2500 + [char]0x2500 + ' TEAM ' + [char]0x2014 + ' elegant grid ' + [char]0x2500 + [char]0x2500 + [char]0x2500 + ' */'
$teamCssNew = '/* ' + [char]0x2500 + [char]0x2500 + [char]0x2500 + ' TEAM ' + [char]0x2014 + ' film strip ' + [char]0x2500 + [char]0x2500 + [char]0x2500 + ' */'
$content = $content.Replace($teamCssOld, $teamCssNew)

# Replace team-grid CSS with film strip CSS
$gridCss = @"
    .team-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 1px;
      background: var(--rim);
      margin-top: 64px;
    }

    .team-card {
      background: var(--surface);
      padding: 56px 40px 52px;
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      gap: 0;
      position: relative;
      overflow: hidden;
      transition: background .4s;
    }

    .team-card:hover {
      background: var(--card);
    }

    .team-card::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 0;
      width: 0;
      height: 1px;
      background: linear-gradient(to right, var(--fire), var(--fire2));
      transition: width .5s ease;
    }

    .team-card:hover::after {
      width: 100%;
    }

    .team-idx {
      font-family: var(--font-mono);
      font-size: .48rem;
      letter-spacing: 3px;
"@

$filmCss = @"
    .team-strip-wrap {
      position: relative;
      margin-top: 60px;
      overflow: hidden;
    }

    .team-strip-wrap::before,
    .team-strip-wrap::after {
      content: '';
      position: absolute;
      top: 0;
      bottom: 0;
      width: 160px;
      z-index: 2;
      pointer-events: none;
    }

    .team-strip-wrap::before {
      left: 0;
      background: linear-gradient(to right, var(--void), transparent);
    }

    .team-strip-wrap::after {
      right: 0;
      background: linear-gradient(to left, var(--void), transparent);
    }

    .film-track {
      display: flex;
      gap: 0;
      animation: film 24s linear infinite;
      width: max-content;
    }

    .film-track:hover {
      animation-play-state: paused;
    }

    .film-frame {
      width: 240px;
      flex-shrink: 0;
      padding: 44px 28px;
      border-right: 1px solid var(--rim);
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 14px;
      position: relative;
      transition: background .35s;
    }

    .film-frame::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 2px;
      background: repeating-linear-gradient(to right, var(--rim) 0, var(--rim) 8px, transparent 8px, transparent 16px);
    }

    .film-frame::after {
      content: '';
      position: absolute;
      bottom: 0; left: 0; right: 0;
      height: 2px;
      background: repeating-linear-gradient(to right, var(--rim) 0, var(--rim) 8px, transparent 8px, transparent 16px);
    }

    .film-frame:hover {
      background: var(--surface);
    }

    .film-frame:hover .f-init {
      border-color: var(--fire);
      color: var(--fire2);
    }

    .f-num {
      font-family: var(--font-mono);
      font-size: .5rem;
      letter-spacing: 2px;
"@

$content = $content.Replace($gridCss.Trim(), $filmCss.Trim())

# Remove old team-card CSS that follows (team-name, team-role, team-card-line, team-bg-num)
$oldTeamDetailsCss = @"
      margin-bottom: 28px;
    }

    .team-name {
      font-family: var(--font-display);
      font-size: 1.55rem;
      font-weight: 400;
      color: var(--snow);
      line-height: 1.2;
      margin-bottom: 14px;
    }

    .team-role {
      font-size: .52rem;
      font-weight: 600;
      letter-spacing: 3.5px;
      text-transform: uppercase;
      color: var(--fire);
    }

    .team-card-line {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      height: 1px;
      background: linear-gradient(to right, transparent, var(--fire), transparent);
      opacity: 0;
      transition: opacity .4s;
    }

    .team-card:hover .team-card-line {
      opacity: .4;
    }

    .team-bg-num {
      position: absolute;
      right: 16px;
      bottom: -8px;
      font-family: var(--font-display);
      font-size: 7rem;
      font-weight: 400;
      font-style: italic;
"@

$newTeamDetailsCss = @"
      color: var(--rim);
    }

    .f-init {
      width: 72px;
      height: 72px;
      border-radius: 50%;
      border: 1px solid var(--rim);
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: var(--font-display);
      font-size: 1.3rem;
      font-weight: 400;
      color: var(--muted);
      transition: border-color .3s, color .3s;
    }

    .f-name {
      font-family: var(--font-display);
      font-size: 1rem;
      font-weight: 400;
      color: var(--snow);
      text-align: center;
      line-height: 1.4;
    }

    .f-role {
      font-size: .52rem;
      letter-spacing: 3px;
      text-transform: uppercase;
      color: var(--fire);
      margin-top: 4px;
    }

    @keyframes film {
      from { transform: translateX(0) }
      to { transform: translateX(-50%) }
    }

    .tooltip-host {
      position: relative;
    }
    .tooltip-host::after {
      content: attr(data-tooltip);
      position: absolute;
      bottom: 100%;
      left: 50%;
      transform: translateX(-50%) translateY(10px);
      background: var(--card);
      color: var(--snow);
      padding: 12px 16px;
      border: 1px solid var(--glass-border);
      border-radius: 8px;
      font-size: 0.75rem;
      white-space: pre-wrap;
      width: max-content;
      max-width: 280px;
      line-height: 1.5;
      text-transform: none;
      letter-spacing: 0.5px;
      box-shadow: 0 10px 30px rgba(0,0,0,0.5);
      opacity: 0;
      pointer-events: none;
      transition: opacity 0.3s, transform 0.3s;
      z-index: 100;
    }
    .tooltip-host:hover::after {
      opacity: 1;
      transform: translateX(-50%) translateY(-10px);
    }

    .team-bg-num-placeholder {
      display: none;
"@

$content = $content.Replace($oldTeamDetailsCss.Trim(), $newTeamDetailsCss.Trim())

# Remove leftover old team css
$oldRemaining = @"
      pointer-events: none;
      transition: color .4s;
    }

    .team-card:hover .team-bg-num {
"@

$newRemaining = @"
      pointer-events: none;
    }

    .placeholder-hover {
"@

$content = $content.Replace($oldRemaining.Trim(), $newRemaining.Trim())

# Write back with UTF-8 BOM to preserve Turkish chars
[System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)

Write-Host "All changes applied successfully!"
