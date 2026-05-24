import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import 'auth_entry_sheet.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glassmorphic_container.dart';

class AuthStatusButton extends StatelessWidget {
  const AuthStatusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isAuthenticated = state.isAuthenticated;
        final session = state.session;
        final photoUrl = session?.photoUrl;
        final initial = session?.displayName != null && session!.displayName!.isNotEmpty
            ? session.displayName![0].toUpperCase()
            : session?.email != null && session!.email!.isNotEmpty
                ? session.email![0].toUpperCase()
                : '?';

        return GestureDetector(
          onTap: () => AuthEntrySheet.show(context),
          child: GlassmorphicContainer(
            padding: EdgeInsets.zero,
            borderRadius: 24,
            width: 48,
            height: 48,
            useBorder: true,
            borderColor: isAuthenticated
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.outlineVariant.withValues(alpha: 0.3),
            child: Center(
              child: photoUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        photoUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    )
                  : isAuthenticated
                      ? Text(
                          initial,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      : const Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 20,
                        ),
            ),
          ),
        );
      },
    );
  }
}
