import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_bloc.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_event.dart';
import 'package:sonic_nomad/features/canvas/presentation/bloc/canvas_state.dart';
import 'package:sonic_nomad/features/canvas/presentation/widgets/infinite_canvas.dart';
import 'package:sonic_nomad/features/musicbrainz/presentation/bloc/musicbrainz_bloc.dart';
import 'package:sonic_nomad/features/musicbrainz/presentation/bloc/musicbrainz_event.dart';
import 'package:sonic_nomad/features/musicbrainz/presentation/bloc/musicbrainz_state.dart';
import 'package:sonic_nomad/features/musicbrainz/presentation/widgets/search_bar_widget.dart';
import 'package:sonic_nomad/features/musicbrainz/presentation/widgets/search_results_list.dart';
import 'package:sonic_nomad/core/theme/app_colors.dart';
import 'package:sonic_nomad/core/theme/app_text_styles.dart';
import 'package:sonic_nomad/core/widgets/glassmorphic_container.dart';
import 'package:sonic_nomad/app/di.dart';
import 'package:sonic_nomad/features/auth/presentation/widgets/auth_status_button.dart';

class CanvasPage extends StatelessWidget {
  const CanvasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<CanvasBloc>()..add(const CanvasInitialized()),
        ),
        BlocProvider(create: (_) => getIt<MusicBrainzBloc>()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            const InfiniteCanvas(),
            // Search Overlay
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              left: 0,
              right: 0,
              child: const Column(
                children: [SearchBarWidget(), _SearchResultsOverlay()],
              ),
            ),
            // Auth Status Overlay
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 16,
              child: const AuthStatusButton(),
            ),
            // Zoom Indicator
            Positioned(
              bottom: 24,
              right: 16,
              child: BlocBuilder<CanvasBloc, CanvasState>(
                buildWhen: (prev, curr) => prev.zoomLevel != curr.zoomLevel,
                builder: (context, state) {
                  return GlassmorphicContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    borderRadius: 20,
                    child: Text(
                      '${(state.zoomLevel * 100).toInt()}%',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultsOverlay extends StatelessWidget {
  const _SearchResultsOverlay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBrainzBloc, MusicBrainzState>(
      builder: (context, state) {
        if (state is MusicBrainzLoaded) {
          return SearchResultsList(
            artists: state.artists,
            onArtistTap: (artist) {
              final size = MediaQuery.of(context).size;
              context.read<CanvasBloc>().add(
                AddNodeEvent(
                  label: artist.name,
                  position: Offset(size.width / 2, size.height / 2),
                  metadata: {
                    'mbid': artist.id,
                    'type': artist.type,
                    'country': artist.country,
                    'score': artist.score,
                  },
                ),
              );
              context.read<MusicBrainzBloc>().add(ClearSearchEvent());
            },
          );
        }
        if (state is MusicBrainzError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GlassmorphicContainer(
              borderRadius: 16,
              padding: const EdgeInsets.all(16),
              child: Text(
                state.message,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
