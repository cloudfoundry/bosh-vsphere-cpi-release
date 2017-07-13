def format_value(v):
    if v is None:
        return 'nil'
    elif type(v) is list or type(v) is tuple:
        inner = ', '.join([ format_value(e) for e in v ])
        return '[{0}]'.format(inner)
    elif type(v) is str:
        return '"{0}"'.format(v)
    else:
        return '{0}'.format(v)

def remove_trailing_empty_hash(seq):
    if (type(seq) is list or type(seq) is tuple) and seq:
        if seq[-1] == {}:
            return [ remove_trailing_empty_hash(child) for child in seq[:-1] ]
        else:
            return [ remove_trailing_empty_hash(child) for child in seq ]
    else:
        return seq

def zero_to_empty_hash(seq):
    if type(seq) is list or type(seq) is tuple:
        return [ zero_to_empty_hash(child) for child in seq ]
    elif seq == 0:
        return {}
    else:
        return seq
