// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:vootday_admin/config/colors.dart';
import 'package:vootday_admin/config/constants/dimens.dart';
import 'package:vootday_admin/screens/calendar/bloc/blocs.dart';
import 'package:vootday_admin/screens/users/widgets/widgets.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late List<DatatableHeader> _headers;
  List<Map<String, dynamic>> _source = [];
  final List<Map<String, dynamic>> _selecteds = [];
  bool _isLoading = true;
  String _searchTerm = '';
  String? _sortColumn;
  bool _sortAscending = true;

  // Variables de pagination
  int _currentPage = 1;
  final int _itemsPerPage = 3;
  int _totalPages = 0;

  String? _selectedRowId;

  void _onRowTap(Map<String, dynamic> rowData) {
    setState(() {
      _selectedRowId = rowData['id'];
      _navigateToEventScreen(context, _selectedRowId!);
    });
  }

  @override
  void initState() {
    super.initState();
    _headers = [
      DatatableHeader(
        text: "id",
        value: "id",
        show: true,
        sortable: true,
      ),
      DatatableHeader(
        text: "brandName",
        value: "brandName",
        show: true,
        sortable: true,
      ),
      DatatableHeader(
        text: "title",
        value: "title",
        show: true,
        sortable: true,
      ),
      DatatableHeader(
        text: "participants",
        value: "participants",
        show: true,
        sortable: true,
      ),
      DatatableHeader(
        text: "reward",
        value: "reward",
        show: true,
        sortable: true,
      ),
      DatatableHeader(
        text: "dateEnd",
        value: "dateEnd",
        show: true,
        sortable: true,
      ),
      DatatableHeader(
        text: "dateEvent",
        value: "dateEvent",
        show: true,
        sortable: true,
      ),
    ];
    _loadData();
  }

  void _loadData() {
    context.read<CalendarEndedBloc>().add(EndedEventsLoadAll());
  }

  void _filterData(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm.toLowerCase();
      _currentPage = 1;
    });
  }

  void _updateCurrentPage(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  void _onSort(dynamic column) {
    if (column is String) {
      if (_sortColumn == column) {
        // Si la colonne est déjà triée, inverser l'ordre de tri
        setState(() {
          _sortAscending = !_sortAscending;
        });
      } else {
        // Si la colonne est différente, définir la nouvelle colonne de tri et réinitialiser l'ordre de tri
        setState(() {
          _sortColumn = column;
          _sortAscending = true;
        });
      }
      // Tri des données
      _source.sort((a, b) {
        dynamic aValue = a[column];
        dynamic bValue = b[column];
        if (aValue is String && bValue is String) {
          return _sortAscending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        } else {
          // Si les valeurs ne sont pas de type String, utilisez compareTo pour les comparer
          return _sortAscending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredList = _source
        .where((user) => user.values.any(
            (value) => value.toString().toLowerCase().contains(_searchTerm)))
        .toList();

    _totalPages = (filteredList.length / _itemsPerPage).ceil();

    List<Map<String, dynamic>> paginatedList;
    if (filteredList.isEmpty) {
      paginatedList = [];
    } else {
      int startRange = (_currentPage - 1) * _itemsPerPage;
      int endRange =
          (_currentPage * _itemsPerPage).clamp(0, filteredList.length);
      paginatedList = filteredList.sublist(startRange, endRange);
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scaffold(
        body: BlocListener<CalendarEndedBloc, CalendarEndedState>(
          listener: (context, state) {
            if (state.status == CalendarEndedStatus.loaded) {
              setState(() {
                _source = state.allEvents;
                _isLoading = false;
                _totalPages = (_source.length / _itemsPerPage).ceil();
              });
            }
          },
          child: _isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 230,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: kDefaultPadding),
                                child: TextField(
                                  onChanged: _filterData,
                                  decoration: const InputDecoration(
                                    hintText: 'Recherche',
                                    suffixIcon: Icon(Icons.search),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: paginatedList.isEmpty
                            ? const Center(child: Text("No result"))
                            : ResponsiveDatatable(
                                headerDecoration: BoxDecoration(
                                  border: Border.all(color: grey),
                                  color: lightBleu,
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(10)),
                                ),
                                headerTextStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: black,
                                ),
                                rowDecoration: BoxDecoration(
                                  border: Border.all(color: grey),
                                ),
                                headers: _headers,
                                selecteds: _selecteds,
                                onSort: _onSort, // Ajout de cette ligne
                                sortColumn: _sortColumn, // Ajout de cette ligne
                                sortAscending:
                                    _sortAscending, // Ajout de cette ligne
                                expanded: List.filled(_source.length, false),
                                source: paginatedList.map((data) {
                                  final bool isSelected =
                                      data['id'] == _selectedRowId;
                                  return {
                                    ...data,
                                    'selected': isSelected,
                                  };
                                }).toList(),
                                onTabRow: (data) {
                                  debugPrint("ligne cliqué");
                                  _onRowTap(data);
                                },
                              ),
                      ),
                    ),
                    buildPaginationControls(
                        _currentPage, _totalPages, _updateCurrentPage),
                  ],
                ),
        ),
      ),
    );
  }
}

void _navigateToEventScreen(BuildContext context, String eventId) {
  GoRouter.of(context).go('/events/event/$eventId', extra: eventId);
}
