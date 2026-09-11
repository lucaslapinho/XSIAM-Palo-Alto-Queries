"""Render reviewed local bindings into a NEW file. Never compile or execute XQL."""
import argparse, hashlib, json, re
from pathlib import Path
from xql_lex import scan, tokens
TOKEN=re.compile(r'\{\{([A-Z][A-Z0-9_]*)\}\}')

def bind(text, values):
    if text.count(':Query:')!=1:
        raise ValueError('Expected exactly one repository query delimiter')
    metadata,body=text.split(':Query:',1)
    if TOKEN.search(metadata):
        raise ValueError('Schema tokens belong only in the executable body')
    required=set(TOKEN.findall(body))
    if not required:
        raise ValueError('This file has no schema bindings; use its query guide for ordinary parameters.')
    if any(kind in ('literal','comment') and TOKEN.search(value) for kind,value in scan(body)):
        raise ValueError('Schema tokens must occupy whole expression/source slots outside literals and comments')
    missing=sorted(k for k in required if not isinstance(values.get(k),str) or not values[k].strip())
    extra=sorted(set(values)-required)
    if missing or extra:
        raise ValueError(f'Missing/unfilled bindings: {missing}; unexpected bindings: {extra}')
    for k,v in values.items():
        if '\n' in v or '\r' in v or '{{' in v or '}}' in v:
            raise ValueError(f'{k}: supply one reviewed identifier, expression or literal on one line')
        # Each binding is a scalar/source/list slot, never a stage or comment slot.
        if any(kind=='comment' or (kind=='punct' and value in ('|',';')) for kind,value in scan(v)):
            raise ValueError(f'{k}: pipeline, statement and comment injection is not a binding')
    result=TOKEN.sub(lambda m:values[m[1]],text)
    if '{{' in result or '}}' in result:
        raise ValueError('Unresolved template markers')
    body=result.split(':Query:',1)[1]
    lex=tokens(body)
    if any(kind=='word' and value.lower()=='target' and (i==0 or lex[i-1]==('punct','|')) for i,(kind,value) in enumerate(lex)):
        raise ValueError('State-changing target stage is outside this binding tool')
    return result

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('query',type=Path);ap.add_argument('bindings',type=Path);ap.add_argument('output',type=Path)
    args=ap.parse_args();provenance=args.output.with_suffix(args.output.suffix+'.binding.json')
    if args.output.exists() or provenance.exists():
        ap.error('Output or provenance already exists; choose a new filename')
    raw=args.query.read_bytes();binding_bytes=args.bindings.read_bytes();config=json.loads(binding_bytes.decode('utf-8'))
    if config.get('source_sha256') and config['source_sha256']!=hashlib.sha256(raw).hexdigest():
        ap.error('Bindings were prepared for a different source hash; review them against this exact template')
    try:result=bind(raw.decode('utf-8'),config['bindings'])
    except (ValueError,KeyError) as e:ap.error(str(e))
    args.output.parent.mkdir(parents=True,exist_ok=True)
    with args.output.open('x',encoding='utf-8',newline='\n') as f:f.write(result)
    evidence={'source_sha256':hashlib.sha256(raw).hexdigest(),'bindings_sha256':hashlib.sha256(binding_bytes).hexdigest(),'output_sha256':hashlib.sha256(args.output.read_bytes()).hexdigest(),'binding_count':len(config['bindings']),'binding_review':'REQUIRED','compiler':'NOT RUN','execution':'NOT RUN','note':'Text substitution only. The source template banner is retained intentionally. Review the complete bound query, types, scope and result semantics before using the editor.'}
    with provenance.open('x',encoding='utf-8',newline='\n') as f:
        f.write(json.dumps(evidence,indent=2)+'\n')
    print(json.dumps(evidence))

if __name__=='__main__':main()
