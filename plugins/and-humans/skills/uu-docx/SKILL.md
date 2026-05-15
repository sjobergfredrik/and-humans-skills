---
name: uu-docx
description: "Create Word documents (.docx) in Uppsala University's official template format. Use this skill whenever the user wants to produce a document for Uppsala University (UU), or mentions 'UU document', 'Uppsala template', 'university report', 'delrapport', 'PM', or similar deliverables intended for UU stakeholders. Also triggers when the user says 'UU format', 'university style', or asks to format something 'like the UU template'. This skill layers on top of the base docx skill — always read the base docx SKILL.md first for general docx-js patterns, then apply the UU-specific formatting from this skill."
---

# Uppsala University Document Skill

Produces .docx files using Uppsala University's official Word template (.dotx) with the UU colour logo in the header. **Edit-based approach** — the original template is preserved byte-for-byte; we only replace body content via XML manipulation.

**Always read `/mnt/skills/public/docx/SKILL.md` first** for the unpack/edit/pack workflow.

---

## How it works

The skill bundles UU's official .dotx template at `assets/uu_template.dotx`. To produce a document:

1. Copy the template
2. Unpack it
3. Replace the body content in `document.xml` with the actual paragraphs
4. Repack

The header (with UU colour logo at 1476375 × 1476375 EMU, positioned with `indent left=-3119`), all footers, styles, theme, and embedded fonts are preserved from the original template.

---

## Template Specifications (for reference)

**Page setup:**
- A4 (11906 × 16838 DXA)
- Margins: top=3261, right=1417, bottom=1417, left=3686, header=568, footer=709
- The large left margin (3686 DXA ≈ 6.5 cm) accommodates the logo overhang

**Logo:**
- UU colour sigill, 496×496 px PNG
- Placed as inline drawing in header2 (the default header)
- Displayed at 1476375 × 1476375 EMU (≈ 41 mm square)
- Header paragraph indented left=-3119 DXA to push logo into left margin

**Theme fonts:**
- Major (headings): Calibri Light
- Minor (body): Calibri
- Default size: inherited from Office defaults (11pt)

**Available styles:** Normal, Heading 1, Heading 2, Header, Footer

---

## Step-by-step implementation

### Step 1: Copy and unpack

```bash
cp /mnt/skills/user/uu-docx/assets/uu_template.dotx /home/claude/working.docx
python scripts/office/unpack.py /home/claude/working.docx /home/claude/uu_unpacked/
```

### Step 2: Replace body content in document.xml

The template body XML looks like this:

```xml
<w:body>
  <w:p w:rsidR="00445B68" w:rsidRDefault="00000000">
    <w:r>
      <w:t>Det här är en vanlig Wordfil med logotypen inlagd i hörnet.</w:t>
    </w:r>
  </w:p>
  <w:p w:rsidR="00CE0B8E" w:rsidRDefault="00CE0B8E">
    <w:pPr>
      <w:ind w:left="426"/>
    </w:pPr>
  </w:p>
  <w:sectPr ...>
    <!-- DO NOT TOUCH sectPr — it defines page layout and header/footer refs -->
  </w:sectPr>
</w:body>
```

**Replace everything between `<w:body>` and `<w:sectPr` with your content paragraphs.** Keep the `<w:sectPr>` block intact.

Use the `str_replace` tool to do this. The old string is the two placeholder `<w:p>` elements; the new string is your content paragraphs.

### Content paragraph patterns

**Heading 1:**
```xml
<w:p>
  <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
  <w:r><w:t>Heading text</w:t></w:r>
</w:p>
```

**Heading 2:**
```xml
<w:p>
  <w:pPr><w:pStyle w:val="Heading2"/></w:pPr>
  <w:r><w:t>Heading text</w:t></w:r>
</w:p>
```

**Normal paragraph:**
```xml
<w:p>
  <w:r><w:t>Body text here.</w:t></w:r>
</w:p>
```

**Bold text within a paragraph:**
```xml
<w:r>
  <w:rPr><w:b/></w:rPr>
  <w:t>Bold text</w:t>
</w:r>
```

**Italic text:**
```xml
<w:r>
  <w:rPr><w:i/></w:rPr>
  <w:t>Italic text</w:t>
</w:r>
```

**Bullet list item** (uses Word's built-in List Bullet numbering, numId="1"):
```xml
<w:p>
  <w:pPr>
    <w:numPr>
      <w:ilvl w:val="0"/>
      <w:numId w:val="1"/>
    </w:numPr>
  </w:pPr>
  <w:r><w:t>Bullet item</w:t></w:r>
</w:p>
```

Note: If bullets don't render (because this template has no numbering.xml), add a simple `numbering.xml` — see "Adding bullet support" below.

**Page break:**
```xml
<w:p>
  <w:r><w:br w:type="page"/></w:r>
</w:p>
```

**Whitespace preservation** — if text starts or ends with spaces:
```xml
<w:t xml:space="preserve"> text with spaces </w:t>
```

**Smart quotes** — always use XML entities for professional typography:
```xml
<w:t>Here&#x2019;s a quote: &#x201C;Hello&#x201D;</w:t>
```

### Step 3: Repack and validate

```bash
python scripts/office/pack.py /home/claude/uu_unpacked/ /home/claude/output.docx --original /home/claude/working.docx
python scripts/office/validate.py /home/claude/output.docx
cp /home/claude/output.docx /mnt/user-data/outputs/filename.docx
```

---

## Adding bullet support

If you need bullet lists and the template lacks a `numbering.xml`, create one:

1. Create `/home/claude/uu_unpacked/word/numbering.xml`:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:numbering xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:abstractNum w:abstractNumId="0">
    <w:lvl w:ilvl="0">
      <w:start w:val="1"/>
      <w:numFmt w:val="bullet"/>
      <w:lvlText w:val="&#x2022;"/>
      <w:lvlJc w:val="left"/>
      <w:pPr>
        <w:ind w:left="720" w:hanging="360"/>
      </w:pPr>
    </w:lvl>
  </w:abstractNum>
  <w:num w:numId="1">
    <w:abstractNumId w:val="0"/>
  </w:num>
</w:numbering>
```

2. Add relationship in `word/_rels/document.xml.rels`:
```xml
<Relationship Id="rId20" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/numbering" Target="numbering.xml"/>
```

3. Add content type in `[Content_Types].xml` if not present:
```xml
<Override PartName="/word/numbering.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.numbering+xml"/>
```

---

## Complete example

Here's a full workflow producing a UU-formatted report:

```bash
# 1. Copy template
cp /mnt/skills/user/uu-docx/assets/uu_template.dotx /home/claude/working.docx
python scripts/office/unpack.py /home/claude/working.docx /home/claude/uu_unpacked/
```

Then use str_replace to swap body content:

**old_str** (the two placeholder paragraphs — everything from the first `<w:p` after `<w:body>` up to but NOT including `<w:sectPr`):
```
    <w:p w:rsidR="00445B68" w:rsidRDefault="00000000">
      <w:r>
        <w:t>Det här är en vanlig Wordfil med logotypen inlagd i hörnet.</w:t>
      </w:r>
    </w:p>
    <w:p w:rsidR="00CE0B8E" w:rsidRDefault="00CE0B8E">
      <w:pPr>
        <w:ind w:left="426"/>
      </w:pPr>
    </w:p>
```

**new_str** (your actual content):
```xml
    <w:p>
      <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
      <w:r><w:t>Report Title Here</w:t></w:r>
    </w:p>
    <w:p>
      <w:r><w:t>Your body text here.</w:t></w:r>
    </w:p>
```

Then pack:
```bash
python scripts/office/pack.py /home/claude/uu_unpacked/ /home/claude/output.docx --original /home/claude/working.docx
python scripts/office/validate.py /home/claude/output.docx
cp /home/claude/output.docx /mnt/user-data/outputs/
```

---

## Key rules

- **Never modify `<w:sectPr>`** — it contains page layout, margins, and header/footer references
- **Never modify header2.xml** — it contains the UU logo
- **Never modify `word/media/image1.png`** — it's the UU colour sigill
- Use `str_replace` tool for XML edits, not Python scripts
- Always validate after packing
- Use smart quotes (XML entities) for Swedish text
