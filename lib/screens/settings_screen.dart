import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../monetization/monetization.dart';
import '../state/app_state.dart';
import '../theme/tokens.dart';
import '../widgets/common.dart';

/// Public privacy policy page, also linked from the store listings. `#francais` jumps to the French half.
const _privacyPolicyUrl = 'https://moosanaqviech.github.io/canadiancitizenship/privacy-policy.html';

/// 06 Settings (English / French).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final state = AppScope.of(context);
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 16, Metrics.gutter, 0),
              sliver: SliverList.list(children: [
                Row(
                  children: [
                    SquareIconButton(
                      icon: Icons.chevron_left_rounded,
                      tooltip: l.back,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Semantics(
                        header: true,
                        child: Text(l.settingsTitle, style: context.text.displayMedium!.copyWith(color: c.forest)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Text(l.language, style: context.text.titleLarge!.copyWith(fontSize: 19)),
                const SizedBox(height: 12),
                _LanguageToggle(
                  selected: lang,
                  onChanged: (code) => state.setLocale(Locale(code)),
                ),
                const SizedBox(height: 20),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.textSize, style: context.text.titleLarge!.copyWith(fontSize: 19)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ExcludeSemantics(
                            child: Text('A', style: context.text.labelMedium!.copyWith(fontSize: 16, color: c.inkSecondary)),
                          ),
                          Expanded(
                            child: Slider(
                              value: state.textSizeIndex.toDouble(),
                              max: (textSizes.length - 1).toDouble(),
                              divisions: textSizes.length - 1,
                              semanticFormatterCallback: (v) => l.textSizeValue(textSizes[v.round()].round()),
                              onChanged: (v) => state.setTextSizeIndex(v.round()),
                            ),
                          ),
                          ExcludeSemantics(
                            child: Text('A', style: context.text.labelMedium!.copyWith(fontSize: 30, color: c.inkSecondary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsetsDirectional.all(18),
                        decoration: BoxDecoration(color: c.birch, borderRadius: BorderRadius.circular(16)),
                        child: Text(l.textSizePreview, style: context.text.bodyLarge!.copyWith(fontSize: 19)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppCard(
                  padding: const EdgeInsetsDirectional.fromSTEB(22, 10, 14, 14),
                  child: Column(
                    children: [
                      MergeSemantics(
                        child: InkWell(
                          onTap: () => state.setHighContrast(!state.highContrast),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _SettingText(title: l.higherContrast, subtitle: l.higherContrastSub),
                                ),
                                Transform.scale(
                                  scale: 1.4,
                                  child: Checkbox(
                                    value: state.highContrast,
                                    onChanged: (v) => state.setHighContrast(v ?? false),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(height: 20, color: c.mist, endIndent: 8),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8, bottom: 6),
                        child: MergeSemantics(
                          child: _SettingText(title: l.calmMotion, subtitle: l.calmMotionSub),
                        ),
                      ),
                    ],
                  ),
                ),
                if (MonetizationScope.of(context).enabled) ...[
                  const SizedBox(height: 20),
                  const _RemoveAdsCard(),
                ],
                const SizedBox(height: 20),
                AppCard(
                  padding: const EdgeInsetsDirectional.fromSTEB(22, 10, 14, 10),
                  child: MergeSemantics(
                    child: InkWell(
                      onTap: () => launchUrl(
                        Uri.parse(lang == 'fr' ? '$_privacyPolicyUrl#francais' : _privacyPolicyUrl),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(child: _SettingText(title: l.privacyPolicy, subtitle: l.privacyPolicySub)),
                            Icon(Icons.open_in_new_rounded, size: 24, color: c.inkSecondary),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(Metrics.gutter, 32, Metrics.gutter, 20),
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Text(l.disclaimer, style: context.text.bodyMedium!.copyWith(color: c.inkSecondary, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One-time purchase that turns ads off, plus the consent controls ads need.
class _RemoveAdsCard extends StatelessWidget {
  const _RemoveAdsCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final c = context.colors;
    final m = MonetizationScope.of(context);
    final price = m.removeAdsPrice;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (m.adsRemoved)
            Text(l.adsRemoved, style: context.text.bodyLarge)
          else ...[
            _SettingText(title: l.removeAdsTitle, subtitle: l.removeAdsSub),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: m.purchasePending
                    ? l.purchasePending
                    : price == null
                        ? l.removeAdsUnavailable
                        : l.removeAdsButton(price),
                variant: ButtonVariant.dark,
                onPressed: price == null || m.purchasePending ? null : m.buyRemoveAds,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: AppButton(label: l.restorePurchase, variant: ButtonVariant.quiet, onPressed: m.restorePurchases),
            ),
          ],
          if (m.privacyOptionsRequired) ...[
            Divider(height: 32, color: c.mist),
            MergeSemantics(
              child: InkWell(
                onTap: m.showPrivacyOptions,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(child: _SettingText(title: l.privacyChoices, subtitle: l.privacyChoicesSub)),
                      Icon(Icons.chevron_right_rounded, size: 28, color: c.inkSecondary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SettingText extends StatelessWidget {
  const _SettingText({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.text.titleMedium!.copyWith(fontSize: 20)),
        const SizedBox(height: 2),
        Text(subtitle, style: context.text.bodyMedium!.copyWith(color: context.colors.inkSecondary, fontSize: 16)),
      ],
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.selected, required this.onChanged});

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Language names are always shown in their own language.
    const options = [('en', 'English'), ('fr', 'Français')];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: c.mist, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          for (final (code, name) in options)
            Expanded(
              child: Semantics(
                selected: code == selected,
                button: true,
                child: Material(
                  color: code == selected ? c.forest : Colors.transparent,
                  borderRadius: BorderRadius.circular(Metrics.buttonRadius),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Metrics.buttonRadius),
                    onTap: () => onChanged(code),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: Metrics.buttonHeight),
                      child: Center(
                        child: Text(
                          name,
                          locale: Locale(code),
                          style: context.text.labelLarge!.copyWith(color: code == selected ? Colors.white : c.forest),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
