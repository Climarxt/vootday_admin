// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:vootday_admin/screens/users/bloc/profile/profile_bloc.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late List<DatatableHeader> _headers;
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<bool>? _expanded;
  int _total = 100;
  int? _currentPerPage = 10;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _headers = [
      DatatableHeader(
        text: "id",
        value: "id",
      ),
      DatatableHeader(
        text: "username",
        value: "username",
      ),
    ];
    _loadData();
  }

  _initializeData() async {
    _mockPullData();
  }

  _mockPullData() async {
    _expanded = List.generate(_currentPerPage!, (index) => false);

    setState(() => _isLoading = true);
    Future.delayed(Duration(seconds: 3)).then((value) {
      _sourceOriginal.clear();
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
      setState(() => _isLoading = false);
    });
  }

  void _loadData() {
    context.read<ProfileBloc>().add(ProfileLoadAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Responsive Data Table"),
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.loaded) {
            // Ajout d'une vérification pour s'assurer que la liste n'est pas null
            if (state.allUsers != null) {
              setState(() {
                _source = state.allUsers;
                _isLoading = false;
              });
              debugPrint("DEBUG 3:$_source");
              debugPrint("DEBUG 3:$_headers");
            } else {
              // Gérer le cas où state.allUsers est null
              debugPrint("Error: allUsers is null");
            }
          }
        },
        child: _isLoading
            ? const CircularProgressIndicator()
            : ResponsiveDatatable(
                headers: _headers,
                selecteds: _selecteds,
                expanded: List.filled(_source.length, false),
                source: _source.isNotEmpty
                    ? _source
                    : null, // Ajout d'une vérification ici
              ),
      ),
    );
  }
}
