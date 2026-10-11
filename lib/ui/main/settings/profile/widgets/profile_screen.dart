import 'package:flutter/material.dart';
import 'package:my_travel_app/components/BasicTextField.dart';
import 'package:my_travel_app/ui/core/ui/top_app_bar.dart';
import 'package:my_travel_app/ui/main/settings/profile/view_models/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileViewModel viewModel;

  const ProfileScreen({super.key, required this.viewModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final viewModel = widget.viewModel;
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
    final viewModel = widget.viewModel;
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final name = _profileNameController.text;
        final initial = (name.isNotEmpty ? name : viewModel.email).characters.firstOrNull ?? "?";
        return Scaffold(
          appBar: TopAppBar(title: "Profile", automaticallyImplyLeading: true),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 8),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                  child: Text(
                    initial.toUpperCase(),
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: Icon(Icons.mail_outline, color: colorScheme.primary),
                  title: Text("Email", style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                  subtitle: Text(viewModel.email, style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
              BasicTextField(
                controller: _profileNameController,
                labelText: "プロフィール名",
                hintText: "みんなに表示される名前",
                prefixIcon: const Icon(Icons.badge_outlined),
                readOnly: !viewModel.editMode,
                enabled: viewModel.editMode,
                onChanged: (name) {},
              ),
              const SizedBox(height: 16),
              if (viewModel.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (viewModel.editMode)
                FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  icon: const Icon(Icons.check),
                  label: const Text("保存"),
                  onPressed: () async {
                    /* 保存する */
                    final ret = await viewModel.updateProfileName(_profileNameController.text);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).clearSnackBars();
                    if (ret.isSuccess) {
                      viewModel.switchEditMode();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("プロフィール名を保存しました")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${ret.error?.errorMessage}")));
                    }
                  },
                )
              else
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text("変更"),
                  onPressed: () {
                    viewModel.switchEditMode();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
