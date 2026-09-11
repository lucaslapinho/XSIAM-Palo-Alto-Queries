"""Lexical helper, not an XQL compiler."""
def scan(text):
    """Keep strings/backtick identifiers intact; recognize comments and punctuation."""
    i = 0
    while i < len(text):
        if text[i].isspace():
            j = i + 1
            while j < len(text) and text[j].isspace():
                j += 1
            yield ('space', text[i:j])
            i = j
        elif text.startswith('//', i):
            j = text.find('\n', i)
            if j < 0:
                j = len(text)
            yield ('comment', text[i:j])
            i = j
        elif text.startswith('/*', i):
            j = text.find('*/', i + 2)
            if j < 0:
                raise ValueError('Unclosed block comment')
            j += 2
            yield ('comment', text[i:j])
            i = j
        elif text[i] in '"\'`':
            delimiter = text[i] * 3 if text.startswith(text[i] * 3, i) else text[i]
            j = i + len(delimiter)
            while j < len(text):
                if text[j] == '\\' and len(delimiter) == 1:
                    j += 2
                    continue
                if text.startswith(delimiter, j):
                    j += len(delimiter)
                    break
                j += 1
            else:
                raise ValueError('Unclosed literal')
            yield ('literal', text[i:j])
            i = j
        elif text[i].isalnum() or text[i] == '_':
            j = i + 1
            while j < len(text) and (text[j].isalnum() or text[j] == '_'):
                j += 1
            yield ('word', text[i:j])
            i = j
        else:
            yield ('punct', text[i])
            i += 1

def tokens(text):
    return [(k, v) for k, v in scan(text) if k not in ('space', 'comment')]

def clean(text):
    return ''.join((' ' if k == 'comment' else v for k, v in scan(text)))

def split_top(text, sep):
    parts = []
    current = ''
    depth = 0
    for kind, value in scan(text):
        if kind == 'punct':
            if value in '([{':
                depth += 1
            elif value in ')]}':
                depth -= 1
            if value == sep and depth == 0:
                parts.append(current.strip())
                current = ''
                continue
        current += value
    parts.append(current.strip())
    return parts
