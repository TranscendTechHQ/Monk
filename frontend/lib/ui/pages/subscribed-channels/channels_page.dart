import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helper/constants.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/pages/subscribed-channels/provider/channels_provider.dart';
import 'package:frontend/ui/theme/decorations.dart';
import 'package:frontend/ui/theme/theme.dart';
import 'package:frontend/ui/widgets/bg_wrapper.dart';

class SubscribedChannelsPage extends ConsumerWidget {
  const SubscribedChannelsPage(
      {this.ifAlreadySubscribed, this.onSubscribed, super.key});

  final VoidCallback? ifAlreadySubscribed;
  final VoidCallback? onSubscribed;

  static Route launchRoute(
      {VoidCallback? ifAlreadySubscribed, VoidCallback? onSubscribed}) {
    return MaterialPageRoute<void>(
      builder: (_) => SubscribedChannelsPage(
        ifAlreadySubscribed: ifAlreadySubscribed,
        onSubscribed: onSubscribed,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = channelsProvider;
    final verifyOrganization = ref.watch(provider);

    ref.listen(provider, (previous, next) {
      if (next is AsyncData) {
        final data = next.value;
        if (data != null && data.subscribedChannels.isNotNullEmpty) {
          ifAlreadySubscribed?.call();
        } else {
          // onSubscribed?.call();
        }
      }
    });
    return PageScaffold(
      body: WithMonkAppbar(
        child: Align(
          alignment: Alignment.center,
          child: verifyOrganization.maybeWhen(
            orElse: () {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: context.scale(140),
                    height: context.scale(140),
                  ),
                  const SizedBox(height: 32),
                  Text('Getting your workspace details...',
                      style: context.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              );
            },
            data: (value) {
              if (value.publicChannels.isNotNullEmpty &&
                  value.subscribedChannels.isNullOrEmpty) {
                return const PublicChannelList();
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/logo.png',
                      width: context.scale(140),
                      height: context.scale(140),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text('Monk app is not installed',
                      style: context.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Text(
                    'Please contact your workspace admin and ask him to install Monk app.',
                    style: context.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ).p16,
                  const SizedBox(height: 32),
                  TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: context.customColors.sourceAlert,
                    ),
                    icon: const Icon(Icons.logout),
                    label: Text(
                      'Log out',
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: context.customColors.sourceAlert,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              );
            },
            error: (error, stackTrace) {
              return const Text('Error verifying organization');
            },
          ),
        ),
      ),
    );
  }
}

class PublicChannelList extends ConsumerWidget {
  const PublicChannelList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = channelsProvider;
    final verifyOrganization = ref.watch(provider);
    final publicChannels = verifyOrganization.value?.publicChannels ?? [];
    final selectedChannels = verifyOrganization.value?.selectedChannels ?? [];

    if (publicChannels.isNullOrEmpty) {
      return Column(
        children: [
          Text(
            'Select channels to subscribe',
            style: context.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
        ],
      );
    }
    return SizedBox(
      width: context.scale(containerWidth),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your workspace has ${publicChannels.length} channels. Select channels to subscribe',
                style: context.textTheme.bodySmall,
              ),
              FilledButton.tonal(
                style: const ButtonStyle(),
                onPressed: selectedChannels.isNullOrEmpty
                    ? null
                    : () async {
                        loader.showLoader(context, message: 'Subscribing...');
                        await ref
                            .read(provider.notifier)
                            .subscribedChannelsAsync();

                        loader.hideLoader();
                      },
                child: const Text('Subscribe'),
              )
            ],
          ).pB(8),
          ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemBuilder: (context, index) {
              final channel = publicChannels[index];
              final isSelected = selectedChannels
                  .where((element) => element.id == channel.id)
                  .isNotEmpty;

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecorations.cardDecoration(context),
                child: CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    ref.read(provider.notifier).addToSubscribedChannels(
                          channel,
                        );
                  },
                  title: Text(channel.name!),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: publicChannels.length,
          ).extended,
        ],
      ),
    );
  }
}
