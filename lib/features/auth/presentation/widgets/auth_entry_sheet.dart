import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'email_auth_form.dart';
import 'social_sign_in_buttons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthEntrySheet extends StatelessWidget {
  const AuthEntrySheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => const AuthEntrySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(
              color: AppColors.outlineVariant,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handlebar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.isAuthenticated) {
                    // Close the sheet upon successful authentication
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  switch (state.status) {
                    case AuthStatus.initial:
                    case AuthStatus.guest:
                    case AuthStatus.failure:
                      return _buildGuestContent(context, state);
                    case AuthStatus.loading:
                      return _buildLoadingContent();
                    case AuthStatus.authenticated:
                      return _buildAuthenticatedContent(context, state);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestContent(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const EmailAuthForm(),
        const SizedBox(height: 20),
        const SocialSignInButtons(),
        if (state.isFailure && state.errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            state.errorMessage!,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingContent() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildAuthenticatedContent(BuildContext context, AuthState state) {
    final session = state.session;
    if (session == null) return const SizedBox.shrink();

    final avatarUrl = session.photoUrl;
    final displayName = session.displayName ?? session.email ?? 'Authenticated User';
    final email = session.email;

    return Column(
      children: [
        Text(
          'Account Details',
          style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 24),
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.surfaceVariant,
          backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
          child: avatarUrl == null
              ? const Icon(
                  Icons.person,
                  size: 40,
                  color: AppColors.primary,
                )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          displayName,
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20, color: Colors.white),
        ),
        if (email != null && email != displayName) ...[
          const SizedBox(height: 4),
          Text(
            email,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
          ),
        ],
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {
            context.read<AuthBloc>().add(AuthSignOutRequested());
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            'Sign Out',
            style: AppTextStyles.labelMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
