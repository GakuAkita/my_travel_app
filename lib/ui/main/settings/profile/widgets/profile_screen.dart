import 'package:flutter/material.dart';
import 'package:my_travel_app/components/BasicTextField.dart';
import 'package:my_travel_app/components/RoundedButton.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/settings/profile/view_models/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final viewModel = context.read<ProfileViewModel>();
    Future.microtask(() async {
      final ret = await viewModel.getProfileName();
      _profileNameController.text = ret;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();
    return Scaffold(
      appBar: TopAppBar(title: "Profile", automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [Text("Email: ${viewModel.email}")]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: BasicTextField(
                      controller: _profileNameController,
                      hintText: "プロフィール名",
                      readOnly: !viewModel.editMode,
                      enabled: viewModel.editMode,
                      onChanged: (name) {},
                    ),
                  ),
                  viewModel.isLoading
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CircularProgressIndicator(),
                      )
                      : Expanded(
                        flex: 5,
                        child: RoundedButton(
                          title: viewModel.editMode ? "保存" : "変更",
                          onPressed: () async {
                            if (viewModel.editMode) {
                              /* 保存する */
                              final ret = await viewModel.updateProfileName(
                                _profileNameController.text,
                              );
                              if (ret.isSuccess) {
                                viewModel.switchEditMode();
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("プロフィール名を保存しました")),
                                );
                              } else {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${ret.error?.errorMessage}"),
                                  ),
                                );
                              }
                            } else {
                              /* プロフィール名が変更できないとき */
                              viewModel.switchEditMode();
                            }
                          },
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
