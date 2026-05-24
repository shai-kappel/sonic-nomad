import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/config/auth_provider_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({super.key});

  void _onProviderTap(BuildContext context, SocialAuthProvider provider) {
    context.read<AuthBloc>().add(AuthSocialSignInRequested(provider));
  }

  @override
  Widget build(BuildContext context) {
    final visibleProviders = AuthProviderConfig.getVisibleProviders();

    if (visibleProviders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Divider(color: AppColors.outlineVariant, thickness: 1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or continue with',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white38),
              ),
            ),
            const Expanded(
              child: Divider(color: AppColors.outlineVariant, thickness: 1),
            ),
          ],
        ),
        const SizedBox(height: 20),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state.isLoading;
            return Column(
              children: visibleProviders.map((provider) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.outlineVariant),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: isLoading ? null : () => _onProviderTap(context, provider),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _getIconForProvider(provider),
                          const SizedBox(width: 12),
                          Text(
                            _getLabelForProvider(provider),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _getIconForProvider(SocialAuthProvider provider) {
    switch (provider) {
      case SocialAuthProvider.google:
        return const Icon(
          Icons.g_mobiledata,
          color: Colors.redAccent,
          size: 28,
        );
      case SocialAuthProvider.apple:
        return const Icon(
          CupertinoIcons.device_phone_portrait,
          color: Colors.white,
          size: 20,
        );
      case SocialAuthProvider.facebook:
        return const Icon(
          Icons.facebook,
          color: Colors.blueAccent,
          size: 20,
        );
    }
  }

  String _getLabelForProvider(SocialAuthProvider provider) {
    switch (provider) {
      case SocialAuthProvider.google:
        return 'Continue with Google';
      case SocialAuthProvider.apple:
        return 'Continue with Apple';
      case SocialAuthProvider.facebook:
        return 'Continue with Facebook';
    }
  }
}
