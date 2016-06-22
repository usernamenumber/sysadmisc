#!/usr/bin/python
import lxml.etree as E
import zipfile
import os.path, re, sys
import argparse

re_notes_fn = re.compile(r".*/notesSlide[0-9]+\.xml$")
re_skiptext = re.compile(r"^\(CLICK\)$|^[0-9]+$|^\s*$")

def getnotes(fn):
    ns = {'a': 'http://schemas.openxmlformats.org/drawingml/2006/main'}
    z = zipfile.ZipFile(fn)
    text = []
    notes_fns = [ n for n in z.namelist() if re_notes_fn.match(n) ]
    # Sort by the number at the end of each slide "filename"
    # Normal sort doesn't work because it thinks 1 < 10 < 2
    notes_fns.sort(cmp = lambda a,b: cmp(int(re.sub(r'[^0-9]','',a)),int(re.sub(r'[^0-9]','',b))))
    for notes_fn in notes_fns:
        slidetext = []
        s = E.parse(z.open(notes_fn))
        #print "=== "+notes_fn
        for p in s.xpath("//a:p",namespaces=ns):
            paratext = " ".join ([ t.strip().encode('utf-8') for t in p.xpath(".//a:t/text()",namespaces=ns) if not re_skiptext.match(t.strip()) ])
            if len(paratext) > 0:
                slidetext.append(paratext)
                #print "***\n"+paratext+"***\n"
        if len(slidetext) > 0:
            text.append(slidetext)
    return text

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
            description="Extract notes text from one or more OpenDoc (.pptx, Open/LibreOffice) slide decks"
            )
    parser.add_argument('filenames', metavar="FILENAME", nargs="+", help="A .pptx filename")
    args = parser.parse_args()
    for fn in args.filenames:
        if not os.path.exists(fn):
            sys.stderr.write("\n** WARNING: Could not open '%s'. Skipping!\n\n" % fn)
            continue
        for slide in getnotes(fn):
            for para in slide:
                print "%s\n" % para
            print "\n"
        print "\n"
