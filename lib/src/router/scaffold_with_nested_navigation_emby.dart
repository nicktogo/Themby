import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:themby/src/features/emby/data/view_repository.dart';
import 'package:themby/src/localization/string_hardcoded.dart';


class ScaffoldWithNestedNavigationEmby extends ConsumerWidget {
  const ScaffoldWithNestedNavigationEmby({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);

    backButtonListener(Widget child) => BackButtonListener(
      onBackButtonPressed: () async {
        int currentIndex = navigationShell.currentIndex;

        final currentPath = GoRouter.of(context).routerDelegate.currentConfiguration.last.route.path;

        if (currentPath.startsWith('/details/')) {
          ref.refresh(getResumeMediaProvider());
          return false;
        }

        if (currentPath.startsWith('/season/') || currentPath.startsWith('/player') ) {
          return false;
        }

        if (currentIndex == 1) {
          if(currentPath.startsWith('/library')) {
            return false;
          }
          _goBranch(0);
          return true;
        } else if (currentIndex == 0) {
          final routeName = navigationShell.shellRouteContext.routerState.uri.toString();
          if (routeName == '/emby') {
            GoRouter.of(context).go('/home');
            return true;
          }
          return false;
        }
        return false;
      },
      child: child,
    );

    if (size.width < 550) {
      return backButtonListener(
        ScaffoldWithNavigationBar(
          body: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        ),
      );
    } else {
      return backButtonListener(
        ScaffoldWithNavigationRail(
          body: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        ),
      );
    }
  }
}


class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(child: body),
          CupertinoTabBar(
            currentIndex: currentIndex,
            onTap: onDestinationSelected,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.film),
                activeIcon: Icon(CupertinoIcons.film_fill),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.heart),
                activeIcon: Icon(CupertinoIcons.heart_fill),
                label: 'Favorite',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Row(
        children: [
          Container(
            width: 88,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: CupertinoColors.separator.resolveFrom(context),
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 60),
                _buildNavItem(
                  context,
                  icon: CupertinoIcons.film,
                  activeIcon: CupertinoIcons.film_fill,
                  label: 'library'.hardcoded,
                  isSelected: currentIndex == 0,
                  onTap: () => onDestinationSelected(0),
                ),
                const SizedBox(height: 20),
                _buildNavItem(
                  context,
                  icon: CupertinoIcons.heart,
                  activeIcon: CupertinoIcons.heart_fill,
                  label: 'favorite'.hardcoded,
                  isSelected: currentIndex == 1,
                  onTap: () => onDestinationSelected(1),
                ),
              ],
            ),
          ),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected
                ? CupertinoColors.activeBlue
                : CupertinoColors.inactiveGray,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isSelected
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.inactiveGray,
            ),
          ),
        ],
      ),
    );
  }
}
