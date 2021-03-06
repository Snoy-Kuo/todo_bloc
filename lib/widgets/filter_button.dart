// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/blocs/blocs.dart';
import 'package:todo_bloc/common/todos_app_core/todos_app_core.dart';
import 'package:todo_bloc/models/models.dart';

class FilterButton extends StatelessWidget {
  final bool visible;

  FilterButton({required this.visible, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyText2;
    final activeStyle = Theme.of(context)
        .textTheme
        .bodyText2!
        .copyWith(color: Theme.of(context).toggleableActiveColor);
    final filteredTodosBloc = BlocProvider.of<FilteredTodosBloc>(context);
    return BlocBuilder(
        bloc: filteredTodosBloc,
        builder: (BuildContext context, FilteredTodosState state) {
          final button = _Button(
            onSelected: (filter) {
              filteredTodosBloc.add(UpdateFilter(filter));
            },
            activeFilter: state is FilteredTodosLoaded
                ? state.activeFilter
                : VisibilityFilter.all,
            activeStyle: activeStyle,
            defaultStyle: defaultStyle!,
          );
          return AnimatedOpacity(
            opacity: visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 150),
            child: visible ? button : IgnorePointer(child: button),
          );
        });
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    required this.onSelected,
    required this.activeFilter,
    required this.activeStyle,
    required this.defaultStyle,
  }) : super(key: key);

  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final TextStyle activeStyle;
  final TextStyle defaultStyle;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<VisibilityFilter>(
      key: ArchSampleKeys.filterButton,
      tooltip: 'Filter Todos',
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuItem<VisibilityFilter>>[
        PopupMenuItem<VisibilityFilter>(
          key: ArchSampleKeys.allFilter,
          value: VisibilityFilter.all,
          child: Text(
            'Show All',
            style: activeFilter == VisibilityFilter.all
                ? activeStyle
                : defaultStyle,
          ),
        ),
        PopupMenuItem<VisibilityFilter>(
          key: ArchSampleKeys.activeFilter,
          value: VisibilityFilter.active,
          child: Text(
            'Show Active',
            style: activeFilter == VisibilityFilter.active
                ? activeStyle
                : defaultStyle,
          ),
        ),
        PopupMenuItem<VisibilityFilter>(
          key: ArchSampleKeys.completedFilter,
          value: VisibilityFilter.completed,
          child: Text(
            'Show Completed',
            style: activeFilter == VisibilityFilter.completed
                ? activeStyle
                : defaultStyle,
          ),
        ),
      ],
      icon: Icon(Icons.filter_list),
    );
  }
}
