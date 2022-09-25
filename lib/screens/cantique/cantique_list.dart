import 'package:cantique/components/app_text.dart';
import 'package:cantique/screens/cantique/add_cantique.dart';
import 'package:cantique/utils/app_func.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/app_styles.dart';
import '../../utils/providers.dart';

class CantiqueList extends ConsumerStatefulWidget {
  const CantiqueList({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _CantiqueListState();
}

class _CantiqueListState extends ConsumerState<CantiqueList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          "Cantiques",
          size: 18,
          color: getWhite(context),
          
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            ref.watch(fetchAllTest).when(
                data: (data) {
                  if (data.isEmpty) {
                    return const Center(
                      child: Text("No data"),
                    );
                  }

                  return ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(data[index].title),
                        subtitle: Text(data[index].time),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: data.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  );
                },
                error: (err, stackErr) {
                  print(stackErr!);
                  return  Text(stackErr!.toString());
                },
                loading: () => const Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: getWhite(context),
        ),
        onPressed: () {
          navigateToNextPage(context, const AddCantique());
        },
      ),
    );
  }
}
