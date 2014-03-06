#!/usr/bin/env python2
"""
Usage: md [-c] file1 [file2 [...]]
"""
from __future__ import with_statement, absolute_import

import lxml.etree
import lxml.html
import markdown
import os
import re
import StringIO
import sys
import textwrap
import traceback

TPL = """<!doctype html>
<html>
    <head>
        <title>
            %(title)s
        </title>
        <link rel="stylesheet" href="http://yandex.st/highlightjs/8.0/styles/github.min.css">
        <script src="http://yandex.st/highlightjs/8.0/highlight.min.js"></script>
        <script>hljs.initHighlightingOnLoad();</script>
        <style type="text/css">
            body {
                font-family: Arial;
                width: 100%%;
                margin: 0;
                padding: 0;
            }
            #sidebar > h3 {
                padding-left: 4px;
                margin: 4px 0;
            }
            #sidebar > ol {
                padding: 0;
                padding-left: 28px;
            }
            #sidebar ol ol {
                padding-left: 23px;
            }
            #sidebar li {
                padding-top: 4px;
            }
            #sidebar ol, #sidebar li, #sidebar a {
                margin: 0;
                font-weight: bold;
                text-decoration: none
            }
            #content {
                max-width: 680px;
                margin: 20px auto;
            }
            #sidebar {
                width: 200px;
                float: right;
                background-color: #F8F8F8;
                border: 1px solid #DDDDDD;
                padding: 10px;
                margin: 10px;
            }
            p > code, li > code, pre {
                font-family: "Consolas", "Liberation Mono", "Courier", "mono";
                font-size: 13px;
                background-color: #F8F8F8;
                border-radius: 3px;
                border: 1px solid #DDDDDD;
                padding: 1px;
                margin: 2px;
            }
            pre {
                overflow: auto;
            }
        </style>
    </head>
    <body>
        <div id="content">
            %(data)s
        </div>
    </body>
</html>
"""

PARSER = lxml.etree.HTMLParser()
HEADERS = ('h2', 'h3', 'h4', 'h5', 'h6')
content_counter = 0
H1 = None

def postprocess(html, contents = False):
    global content_counter, H1
    sidebar = ''
    last_level = 0
    tree = lxml.etree.parse(StringIO.StringIO(html), PARSER)
    tc = [0]
    tp = 0
    for el in tree.getiterator():
        parent = el.getparent()
        if el.tag in HEADERS and contents:
            if not sidebar:
                sidebar = '<h3>Contents</h3><ol>'
            content_counter += 1
            c = str(content_counter)
            level = int(el.tag[1:])
            anchor = lxml.html.fromstring('<a name="'+c+'"></a>')
            el.insert(-1, anchor)
            if level == last_level:
                sidebar += '<li><a href="#%s">%s</a>' % (c, el.text)
                tc[tp] += 1
            if level < last_level:
                sidebar += '</ol></li>'
                sidebar += '<li><a href="#%s">%s</a>' % (c, el.text)
                tc = tc[:-1]
                tp -= 1
            if level > last_level:
                sidebar += '<ol><li><a href="#%s">%s</a>' % (c, el.text)
                tc.append(1)
                tp += 1
            last_level = level
            el.text = '.'.join([str(i) for i in filter(None, tc)]) + '. ' + el.text
        if el.tag == 'code' and ''.join(parent.itertext()) == ''.join(el.itertext()):
            pre = lxml.html.fromstring('<pre></pre>')
            parent.insert(-1, pre)
            parent.remove(el)
            pre.append(el)
            el.text = textwrap.dedent(el.text)
    if sidebar:
        while level > 2:
            sidebar += '</ul></li>'
            level -= 1
        sidebar += '</ol>'
        sidebar = '<div id="sidebar">'+sidebar+'</div>'
        sidebar = lxml.html.fromstring(sidebar)
        ins = 0
        # Assumes an h1 tag is first
        if tree.findall('body')[0].findall('h1'):
            ins = 1
        tree.findall('body')[0].insert(ins, sidebar)
    return lxml.etree.tostring(tree.findall('body')[0], pretty_print=True, method="html").replace('<body>', '').replace('</body>', '')

if __name__ == "__main__":

    argv = sys.argv[1:]
    contents = False
    if '-c' in argv:
        contents = True
    argv = filter(lambda x: x not in ['-', '-c'], argv)

    if not argv:
        print __doc__.strip()
        sys.exit(1)

    for fname in argv:
        try:
            with open(fname) as f:
                basename = os.path.basename(fname)
                outfile = os.path.splitext(basename)[0] + '.html'
                markdowndata = f.read()
                # Remove Github dialect features
                markdowndata = re.sub(r'```([a-z]+)\w*\n', r'<span><code class="\1">', markdowndata)
                markdowndata = markdowndata.replace('```', '</code></span>')
                markdowndata = markdown.markdown(markdowndata)
                markdowndata = postprocess(markdowndata, contents = contents)
                with open(outfile, 'w') as wf:
                    wf.write(TPL % {
                        'title': outfile,
                        'data': markdowndata,
                    })
        except (IOError, OSError), e:
            traceback.print_exc()