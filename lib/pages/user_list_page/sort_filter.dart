
enum SortType {
  recent,
  oldest,
  // ignore: constant_identifier_names
  a_z,
  // ignore: constant_identifier_names
  z_a
}

final sortFilter = {
  SortType.recent : {
    'label' : 'Più recente',
    'selected' : true,
  },
  SortType.oldest : {
    'label' : 'Più vecchio',
    'selected' : false,
  },
  SortType.a_z : {
    'label' : 'Alfabetico A-Z',
    'selected' : false,
  },
  SortType.z_a : {
    'label' : 'Alfabetico Z-A',
    'selected' : false,
  },
};
