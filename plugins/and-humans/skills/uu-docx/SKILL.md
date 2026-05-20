---
name: uu-docx
description: "Create Word documents (.docx) in Uppsala University's official template format — cover page with logo, title/subtitle, 'Fastställd av' line and Dnr, followed by a body. Use this skill whenever the user wants to produce a document for Uppsala University (UU), or mentions 'UU document', 'Uppsala template', 'university report', 'delrapport', 'PM', 'beslut', 'rektorsbeslut', or similar deliverables intended for UU stakeholders. Also triggers when the user says 'UU format', 'university style', or asks to format something 'like the UU template'. This skill layers on top of the base docx skill — always read the base docx SKILL.md first for general docx-js / unpack-edit-pack patterns, then apply the UU-specific formatting from this skill."
---

# Uppsala University Document Skill

Produces .docx files using Uppsala University's official Word template (`mall.docx`, May 2026 revision). **Edit-based approach** — the original template is preserved byte-for-byte; we only swap placeholder text via XML manipulation.

**Always read `/mnt/skills/public/docx/SKILL.md` first** for the unpack / edit / pack workflow.

---

## Template at a glance

The template is a two-section document:

```
┌─────────────────────────────────────────────────────┐
│  [UU logo]                                Dnr xxx   │  ← Section 1: cover header
│                                                     │     (2-column, no content)
│                                                     │
│  Titel                                              │  ← Title (cover)
│  Undertitel                                         │  ← Subtitle (cover)
│  Fastställd av Namn Datum                           │  ← Avsändare (cover)
│  ────────── page break ──────────                   │
│                                                     │
│  Rubrik                                             │  ← Heading 1 (body)
│  Brödtext...                                        │  ← FirstParagraph (body)
│                                                     │  ← Section 2: body
└─────────────────────────────────────────────────────┘
```

**Page setup:**
- A4 (11906 × 16838 DXA)
- Cover section: 2 columns (6521 + 1982 DXA), top margin 851
- Body section: single column, top margin 2155, left/right 1701
- Headers: `header1.xml` (body default), `header2.xml` (cover default — contains decorative mark), `header3.xml` (body first-page)

**Logo:** inline EMF (vector) drawing in the cover-page body, sized 1080000 × 1030909 EMU (≈ 30 × 29 mm). Embedded at `word/media/image1.emf` via `rId11`. **Do not modify.**

**Theme fonts:** Calibri Light (headings) / Calibri (body) — inherited from theme.

**Built-in numbering.xml** — bullet lists work out of the box via `<w:pStyle w:val="ListBullet"/>` or `<w:numId w:val="1"/>`.

---

## Available named styles

The template ships with a rich set of Swedish-named styles. Use them via `<w:pStyle w:val="StyleId"/>`:

| StyleId | Purpose |
|---|---|
| `Title` | Cover title |
| `Subtitle` | Cover subtitle |
| `Avsndare` | "Fastställd av …" line (note: ä stripped from styleId) |
| `Dnr` | Diarienummer line in cover header |
| `Logotyp` | Paragraph containing the logo drawing |
| `Heading1` … `Heading9` | Body headings |
| `FirstParagraph` | First body paragraph after a heading (no top indent) |
| `BodyText` | Standard body paragraph |
| `ListBullet` | Bullet list item |
| `Strecklista` | Dash list |
| `Tabellrubrik`, `Tabelltext`, `Kolumnrubriker` | Table heading / body / column headers |
| `Beslut`, `Beredningmed`, `BilagorochExpedieras`, `Bilagelista` | Decision-document blocks |
| `Diagramrubrik`, `Fotnot`, `Indrag` | Chart caption / footnote / indented block |

If no `<w:pStyle>` is specified, paragraphs render with the body section's defaults.

---

## Step-by-step implementation

### Step 1: Copy and unpack

```bash
cp /mnt/skills/user/uu-docx/assets/uu_template.docx /home/claude/working.docx
python scripts/office/unpack.py /home/claude/working.docx /home/claude/uu_unpacked/
```

### Step 2: Swap placeholder text in `document.xml`

The template's body contains six replaceable placeholders, each a unique string surrounded by enough XML context to make `str_replace` calls unambiguous. **Edit each placeholder individually** — do not rewrite the whole body, because that would lose the section break, SDT content controls, and bookmarks the template relies on.

#### A. Diarienummer (Dnr)

Find the second `<w:t>Dnr</w:t>` (inside the SDT with `w:alias="Diarienr"`) and replace just the inner text:

```
        <w:rPr>
          <w:rStyle w:val="PlaceholderText"/>
        </w:rPr>
        <w:t>Dnr</w:t>
```
→
```
        <w:t>UFV 2026/123</w:t>
```

(Strip the `rStyle PlaceholderText` so it renders as live text, not greyed placeholder.)

#### B. Title

```xml
<w:r w:rsidR="00242758">
      <w:t>Titel</w:t>
     </w:r>
```
→
```xml
<w:r>
      <w:t>Your document title</w:t>
     </w:r>
```

#### C. Subtitle

```xml
<w:r>
    <w:t>Undertitel</w:t>
   </w:r>
```
→
```xml
<w:r>
    <w:t>Your subtitle (or delete this entire <w:p> if not needed)</w:t>
   </w:r>
```

#### D. Fastställd av — name

```
      <w:rPr>
       <w:rStyle w:val="PlaceholderText"/>
      </w:rPr>
      <w:t>Namn</w:t>
```
→
```
      <w:t>Rektor Anders Hagfeldt</w:t>
```

#### E. Fastställd av — date

```
      <w:rPr>
       <w:rStyle w:val="PlaceholderText"/>
      </w:rPr>
      <w:t>Välj datum</w:t>
```
→
```
      <w:t>2026-05-20</w:t>
```

#### F. Body content — replace heading + first paragraph

This is the main body. Find:

```xml
<w:p w14:paraId="2797FC78" w14:textId="5BA3200B" w:rsidR="009F2599" w:rsidRDefault="00242758" w:rsidP="009F2599">
   <w:pPr>
    <w:pStyle w:val="Heading1"/>
   </w:pPr>
   <w:bookmarkStart w:id="2" w:name="X74a446f5f3d49a724822d5eca8c1cb9fe977051"/>
   <w:r>
    <w:lastRenderedPageBreak/>
    <w:t>Rubrik</w:t>
   </w:r>
  </w:p>
  <w:p w14:paraId="0CBD50F4" w14:textId="6C5A0C25" w:rsidR="009F2599" w:rsidRPr="00242758" w:rsidRDefault="00242758" w:rsidP="009F2599">
   <w:pPr>
    <w:pStyle w:val="FirstParagraph"/>
    <w:rPr>
     <w:lang w:val="sv-SE"/>
    </w:rPr>
   </w:pPr>
   <w:r w:rsidRPr="00242758">
    <w:rPr>
     <w:lang w:val="sv-SE"/>
    </w:rPr>
    <w:t>Brödtext</w:t>
   </w:r>
   <w:bookmarkEnd w:id="2"/>
  </w:p>
```

Replace with as many paragraphs as you need, using the patterns in the next section. Keep the `<w:bookmarkStart>` on your first paragraph and `<w:bookmarkEnd>` on the last — the bookmark is referenced elsewhere and removing it can break Word's XML.

---

## Content paragraph patterns

**Heading 1 / 2 / 3:**
```xml
<w:p>
  <w:pPr><w:pStyle w:val="Heading1"/></w:pPr>
  <w:r><w:t>Heading text</w:t></w:r>
</w:p>
```

**First paragraph after a heading** (use `FirstParagraph` — no top indent):
```xml
<w:p>
  <w:pPr><w:pStyle w:val="FirstParagraph"/></w:pPr>
  <w:r><w:t>Opening body text.</w:t></w:r>
</w:p>
```

**Standard body paragraph:**
```xml
<w:p>
  <w:pPr><w:pStyle w:val="BodyText"/></w:pPr>
  <w:r><w:t>Body text.</w:t></w:r>
</w:p>
```

**Bold / italic runs:**
```xml
<w:r><w:rPr><w:b/></w:rPr><w:t>bold</w:t></w:r>
<w:r><w:rPr><w:i/></w:rPr><w:t>italic</w:t></w:r>
```

**Bullet list** (uses the template's built-in `ListBullet` style):
```xml
<w:p>
  <w:pPr><w:pStyle w:val="ListBullet"/></w:pPr>
  <w:r><w:t>Bullet item</w:t></w:r>
</w:p>
```

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

**Smart quotes** — always use XML entities for professional Swedish typography:
```xml
<w:t>Det är &#x201D;så här&#x201D; man citerar.</w:t>
<w:t>Han sa: &#x2019;Hej&#x2019;.</w:t>
```

---

## Step 3: Repack and validate

```bash
python scripts/office/pack.py /home/claude/uu_unpacked/ /home/claude/output.docx --original /home/claude/working.docx
python scripts/office/validate.py /home/claude/output.docx
cp /home/claude/output.docx /mnt/user-data/outputs/filename.docx
```

---

## Removing cover-page elements

If the document doesn't need a subtitle or the "Fastställd av" line, delete the entire `<w:p>` element wrapping that placeholder. Don't leave empty paragraphs — they create unwanted vertical space on the cover.

If the document needs **no cover at all** (just body text on page 1 with the logo header), this is unusual for UU formatting and you should confirm with the user first. The cover structure is part of the official identity.

---

## Key rules

- **Never modify `<w:sectPr>` blocks** — they define the two-section layout, column geometry, and header references
- **Never modify `header1.xml`, `header2.xml`, or `header3.xml`** — they carry the UU visual identity
- **Never modify `word/media/image1.emf`** — it's the UU sigill (vector)
- **Never modify `word/glossary/`** — it holds the Quick Parts library backing the SDT placeholders
- Use `str_replace` for XML edits, one placeholder at a time
- Keep `<w:bookmarkStart>` / `<w:bookmarkEnd>` pairs intact when replacing body content
- Always run `validate.py` after packing
- Use Swedish smart quotes (`&#x201D;` `&#x2019;`) for any Swedish text
