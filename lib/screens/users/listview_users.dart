// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:vootday_admin/config/colors.dart';
import 'package:vootday_admin/screens/users/bloc/profile/profile_bloc.dart';

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
      DatatableHeader(
        text: "firstName",
        value: "firstName",
      ),
      DatatableHeader(
        text: "lastName",
        value: "lastName",
      ),
      DatatableHeader(
        text: "email",
        value: "email",
      ),
      DatatableHeader(
        text: "username",
        value: "username",
      ),
      DatatableHeader(
        text: "location",
        value: "location",
      ),
      DatatableHeader(
        text: "followers",
        value: "followers",
      ),
      DatatableHeader(
        text: "following",
        value: "following",
      ),
      DatatableHeader(
        text: "selectedGender",
        value: "selectedGender",
      ),
      DatatableHeader(
        text: "username_lowercase",
        value: "username_lowercase",
      ),
    ];
    _loadData();
  }

  void _loadData() {
    context.read<ProfileBloc>().add(ProfileLoadAllUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Scaffold(
        body: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.loaded) {
              setState(() {
                _source = state.allUsers;
                _isLoading = false;
              });
            }
          },
          child: _isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: ResponsiveDatatable(
                    headerDecoration: BoxDecoration(
                      border: Border.all(color: grey),
                      color: lightBleu,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
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
                    expanded: List.filled(_source.length, false),
                    source: _source.isNotEmpty ? _source : null,
                  ),
                ),
        ),
      ),
    );
  }
}
