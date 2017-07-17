class OrList(list):

    def __or__(self, other):
        return OrList(self.__add__(other))

    def __str__(self):
        inner = ', '.join([ ':{0} => true'.format(x) for x in self ])

        return '{{{0}}}'.format(inner)
