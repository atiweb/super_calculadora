import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SpecialFunctionsHelpScreen extends StatelessWidget {
  const SpecialFunctionsHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.hlpTitle),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ============================================================
          // GUÍA DE INICIO RÁPIDO
          // ============================================================
          _SectionHeader(title: l.hlpQuickStartHeader, icon: Icons.rocket_launch),
          _QuickStartCard(l: l),
          const SizedBox(height: 16),

          // ============================================================
          // SISTEMA DE PARÁMETROS
          // ============================================================
          _SectionHeader(title: l.hlpParamHeader, icon: Icons.tune),
          _ParameterSystemCard(l: l),
          const SizedBox(height: 16),

          // ============================================================
          // TEORÍA DE NÚMEROS
          // ============================================================
          _SectionHeader(title: l.hlpNumberTheoryHeader, icon: Icons.calculate),
          _CollapsibleSection(
            title: l.hlpEulerPhiTitle,
            symbol: 'φ',
            params: l.hlpEulerPhiParams,
            description: l.hlpEulerPhiDesc,
            formula: l.hlpEulerPhiFormula,
            examples: [l.hlpEulerPhiEx1, l.hlpEulerPhiEx2, l.hlpEulerPhiEx3, l.hlpEulerPhiEx4],
            tips: [l.hlpEulerPhiTip1, l.hlpEulerPhiTip2, l.hlpEulerPhiTip3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpCarmichaelTitle,
            symbol: 'λ',
            params: l.hlpCarmichaelParams,
            description: l.hlpCarmichaelDesc,
            formula: l.hlpCarmichaelFormula,
            examples: [l.hlpCarmichaelEx1, l.hlpCarmichaelEx2, l.hlpCarmichaelEx3],
            tips: [l.hlpCarmichaelTip1, l.hlpCarmichaelTip2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpMobiusTitle,
            symbol: 'μ',
            params: l.hlpMobiusParams,
            description: l.hlpMobiusDesc,
            formula: l.hlpMobiusFormula,
            examples: [l.hlpMobiusEx1, l.hlpMobiusEx2, l.hlpMobiusEx3, l.hlpMobiusEx4],
            tips: [l.hlpMobiusTip1, l.hlpMobiusTip2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpLiouvilleTitle,
            symbol: 'λL',
            params: l.hlpLiouvilleParams,
            description: l.hlpLiouvilleDesc,
            formula: l.hlpLiouvilleFormula,
            examples: [l.hlpLiouvilleEx1, l.hlpLiouvilleEx2],
            tips: [l.hlpLiouvilleTip1],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpSmallOmegaTitle,
            symbol: 'ω',
            params: l.hlpSmallOmegaParams,
            description: l.hlpSmallOmegaDesc,
            formula: l.hlpSmallOmegaFormula,
            examples: [l.hlpSmallOmegaEx1, l.hlpSmallOmegaEx2, l.hlpSmallOmegaEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpBigOmegaTitle,
            symbol: 'Ω',
            params: l.hlpBigOmegaParams,
            description: l.hlpBigOmegaDesc,
            formula: l.hlpBigOmegaFormula,
            examples: [l.hlpBigOmegaEx1, l.hlpBigOmegaEx2, l.hlpBigOmegaEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpSigma0Title,
            symbol: 'σ₀',
            params: l.hlpSigma0Params,
            description: l.hlpSigma0Desc,
            formula: l.hlpSigma0Formula,
            examples: [l.hlpSigma0Ex1, l.hlpSigma0Ex2, l.hlpSigma0Ex3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpSigmaTitle,
            symbol: 'σ',
            params: l.hlpSigmaParams,
            description: l.hlpSigmaDesc,
            formula: l.hlpSigmaFormula,
            examples: [l.hlpSigmaEx1, l.hlpSigmaEx2, l.hlpSigmaEx3],
            tips: [l.hlpSigmaTip1, l.hlpSigmaTip2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpSopfrTitle,
            symbol: 'sopfr',
            params: l.hlpSopfrParams,
            description: l.hlpSopfrDesc,
            formula: l.hlpSopfrFormula,
            examples: [l.hlpSopfrEx1, l.hlpSopfrEx2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpSopfTitle,
            symbol: 'sopf',
            params: l.hlpSopfParams,
            description: l.hlpSopfDesc,
            formula: l.hlpSopfFormula,
            examples: [l.hlpSopfEx1, l.hlpSopfEx2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpRadTitle,
            symbol: 'rad',
            params: l.hlpRadParams,
            description: l.hlpRadDesc,
            formula: l.hlpRadFormula,
            examples: [l.hlpRadEx1, l.hlpRadEx2, l.hlpRadEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpPrimorialTitle,
            symbol: '#',
            params: l.hlpPrimorialParams,
            description: l.hlpPrimorialDesc,
            formula: l.hlpPrimorialFormula,
            examples: [l.hlpPrimorialEx1, l.hlpPrimorialEx2, l.hlpPrimorialEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpPrimeCountTitle,
            symbol: 'π(n)',
            params: l.hlpPrimeCountParams,
            description: l.hlpPrimeCountDesc,
            formula: l.hlpPrimeCountFormula,
            examples: [l.hlpPrimeCountEx1, l.hlpPrimeCountEx2, l.hlpPrimeCountEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpDigitalRootTitle,
            symbol: 'dr',
            params: l.hlpDigitalRootParams,
            description: l.hlpDigitalRootDesc,
            formula: l.hlpDigitalRootFormula,
            examples: [l.hlpDigitalRootEx1, l.hlpDigitalRootEx2, l.hlpDigitalRootEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpFloorCeilTitle,
            symbol: '⌊⌉',
            params: l.hlpFloorCeilParams,
            description: l.hlpFloorCeilDesc,
            formula: l.hlpFloorCeilFormula,
            examples: [l.hlpFloorCeilEx1, l.hlpFloorCeilEx2, l.hlpFloorCeilEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpPadicTitle,
            symbol: 'Vₚ',
            params: l.hlpPadicParams,
            description: l.hlpPadicDesc,
            formula: l.hlpPadicFormula,
            examples: [l.hlpPadicEx1, l.hlpPadicEx2, l.hlpPadicEx3],
            tips: [l.hlpPadicTip1, l.hlpPadicTip2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          const SizedBox(height: 16),

          // ============================================================
          // ARITMÉTICA MODULAR
          // ============================================================
          _SectionHeader(title: l.hlpModArithHeader, icon: Icons.sync_alt),
          _CollapsibleSection(
            title: l.hlpModTitle,
            symbol: 'mod',
            params: l.hlpModParams,
            description: l.hlpModDesc,
            formula: l.hlpModFormula,
            examples: [l.hlpModEx1, l.hlpModEx2, l.hlpModEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpModPowTitle,
            symbol: 'a%n',
            params: l.hlpModPowParams,
            description: l.hlpModPowDesc,
            formula: l.hlpModPowFormula,
            examples: [l.hlpModPowEx1, l.hlpModPowEx2, l.hlpModPowEx3],
            tips: [l.hlpModPowTip1],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpModInvTitle,
            symbol: 'a⁻¹',
            params: l.hlpModInvParams,
            description: l.hlpModInvDesc,
            formula: l.hlpModInvFormula,
            examples: [l.hlpModInvEx1, l.hlpModInvEx2, l.hlpModInvEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpOrdTitle,
            symbol: 'ord',
            params: l.hlpOrdParams,
            description: l.hlpOrdDesc,
            formula: l.hlpOrdFormula,
            examples: [l.hlpOrdEx1, l.hlpOrdEx2],
            tips: [l.hlpOrdTip1, l.hlpOrdTip2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpLegendreTitle,
            symbol: '(a/p)',
            params: l.hlpLegendreParams,
            description: l.hlpLegendreDesc,
            formula: l.hlpLegendreFormula,
            examples: [l.hlpLegendreEx1, l.hlpLegendreEx2, l.hlpLegendreEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpJacobiTitle,
            symbol: '(a/n)ⱼ',
            params: l.hlpJacobiParams,
            description: l.hlpJacobiDesc,
            formula: l.hlpJacobiFormula,
            examples: [l.hlpJacobiEx1, l.hlpJacobiEx2, l.hlpJacobiEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpPrimRootTitle,
            symbol: 'g',
            params: l.hlpPrimRootParams,
            description: l.hlpPrimRootDesc,
            formula: l.hlpPrimRootFormula,
            examples: [l.hlpPrimRootEx1, l.hlpPrimRootEx2, l.hlpPrimRootEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpGcdTitle,
            symbol: 'MCD',
            params: l.hlpGcdParams,
            description: l.hlpGcdDesc,
            formula: l.hlpGcdFormula,
            examples: [l.hlpGcdEx1, l.hlpGcdEx2, l.hlpGcdEx3],
            tips: [l.hlpGcdTip1, l.hlpGcdTip2, l.hlpGcdTip3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpLcmTitle,
            symbol: 'MCM',
            params: l.hlpLcmParams,
            description: l.hlpLcmDesc,
            formula: l.hlpLcmFormula,
            examples: [l.hlpLcmEx1, l.hlpLcmEx2],
            tips: [l.hlpLcmTip1],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpDiophTitle,
            symbol: 'Diof',
            params: l.hlpDiophParams,
            description: l.hlpDiophDesc,
            formula: l.hlpDiophFormula,
            examples: [l.hlpDiophEx1, l.hlpDiophEx2, l.hlpDiophEx3],
            tips: [l.hlpDiophTip1, l.hlpDiophTip2, l.hlpDiophTip3, l.hlpDiophTip4],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpCrtTitle,
            symbol: 'TCR',
            params: l.hlpCrtParams,
            description: l.hlpCrtDesc,
            formula: l.hlpCrtFormula,
            examples: [l.hlpCrtEx1, l.hlpCrtEx2],
            tips: [l.hlpCrtTip1, l.hlpCrtTip2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          const SizedBox(height: 16),

          // ============================================================
          // COMBINATORIA
          // ============================================================
          _SectionHeader(title: l.hlpCombinatoricsHeader, icon: Icons.grid_view),
          _CollapsibleSection(
            title: l.hlpFactorialTitle,
            symbol: 'n!',
            params: l.hlpFactorialParams,
            description: l.hlpFactorialDesc,
            formula: l.hlpFactorialFormula,
            examples: [l.hlpFactorialEx1, l.hlpFactorialEx2, l.hlpFactorialEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpDblFactorialTitle,
            symbol: 'n!!',
            params: l.hlpDblFactorialParams,
            description: l.hlpDblFactorialDesc,
            formula: l.hlpDblFactorialFormula,
            examples: [l.hlpDblFactorialEx1, l.hlpDblFactorialEx2, l.hlpDblFactorialEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpCombTitle,
            symbol: 'C(n,k)',
            params: l.hlpCombParams,
            description: l.hlpCombDesc,
            formula: l.hlpCombFormula,
            examples: [l.hlpCombEx1, l.hlpCombEx2, l.hlpCombEx3],
            tips: [l.hlpCombTip1, l.hlpCombTip2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpVarTitle,
            symbol: 'V(n,k)',
            params: l.hlpVarParams,
            description: l.hlpVarDesc,
            formula: l.hlpVarFormula,
            examples: [l.hlpVarEx1, l.hlpVarEx2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpCatalanTitle,
            symbol: 'Cat',
            params: l.hlpCatalanParams,
            description: l.hlpCatalanDesc,
            formula: l.hlpCatalanFormula,
            examples: [l.hlpCatalanEx1, l.hlpCatalanEx2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpDerangementTitle,
            symbol: 'D(n)',
            params: l.hlpDerangementParams,
            description: l.hlpDerangementDesc,
            formula: l.hlpDerangementFormula,
            examples: [l.hlpDerangementEx1, l.hlpDerangementEx2, l.hlpDerangementEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpBellTitle,
            symbol: 'Bell',
            params: l.hlpBellParams,
            description: l.hlpBellDesc,
            formula: l.hlpBellFormula,
            examples: [l.hlpBellEx1, l.hlpBellEx2, l.hlpBellEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpPartitionTitle,
            symbol: 'p(n)',
            params: l.hlpPartitionParams,
            description: l.hlpPartitionDesc,
            formula: l.hlpPartitionFormula,
            examples: [l.hlpPartitionEx1, l.hlpPartitionEx2, l.hlpPartitionEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpStirling2Title,
            symbol: 'S₂(n,k)',
            params: l.hlpStirling2Params,
            description: l.hlpStirling2Desc,
            formula: l.hlpStirling2Formula,
            examples: [l.hlpStirling2Ex1, l.hlpStirling2Ex2, l.hlpStirling2Ex3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpStirling1Title,
            symbol: 's₁(n,k)',
            params: l.hlpStirling1Params,
            description: l.hlpStirling1Desc,
            formula: l.hlpStirling1Formula,
            examples: [l.hlpStirling1Ex1, l.hlpStirling1Ex2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpFibTitle,
            symbol: 'F(n)',
            params: l.hlpFibParams,
            description: l.hlpFibDesc,
            formula: l.hlpFibFormula,
            examples: [l.hlpFibEx1, l.hlpFibEx2, l.hlpFibEx3],
            tips: [l.hlpFibTip1, l.hlpFibTip2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpDigitSumBaseTitle,
            symbol: 'ΣdígB',
            params: l.hlpDigitSumBaseParams,
            description: l.hlpDigitSumBaseDesc,
            formula: l.hlpDigitSumBaseFormula,
            examples: [l.hlpDigitSumBaseEx1, l.hlpDigitSumBaseEx2, l.hlpDigitSumBaseEx3],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          const SizedBox(height: 16),

          // ============================================================
          // ESTADÍSTICA
          // ============================================================
          _SectionHeader(title: l.hlpStatisticsHeader, icon: Icons.bar_chart),
          _CollapsibleSection(
            title: l.hlpArithMeanTitle,
            symbol: 'Med A',
            params: l.hlpArithMeanParams,
            description: l.hlpArithMeanDesc,
            formula: l.hlpArithMeanFormula,
            examples: [l.hlpArithMeanEx1, l.hlpArithMeanEx2],
            tips: [l.hlpArithMeanTip1, l.hlpArithMeanTip2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpGeoMeanTitle,
            symbol: 'Med G',
            params: l.hlpGeoMeanParams,
            description: l.hlpGeoMeanDesc,
            formula: l.hlpGeoMeanFormula,
            examples: [l.hlpGeoMeanEx1, l.hlpGeoMeanEx2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpHarmMeanTitle,
            symbol: 'Med H',
            params: l.hlpHarmMeanParams,
            description: l.hlpHarmMeanDesc,
            formula: l.hlpHarmMeanFormula,
            examples: [l.hlpHarmMeanEx1, l.hlpHarmMeanEx2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpQuadMeanTitle,
            symbol: 'Med C',
            params: l.hlpQuadMeanParams,
            description: l.hlpQuadMeanDesc,
            formula: l.hlpQuadMeanFormula,
            examples: [l.hlpQuadMeanEx1, l.hlpQuadMeanEx2],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _CollapsibleSection(
            title: l.hlpMinMaxTitle,
            symbol: 'min/max',
            params: l.hlpMinMaxParams,
            description: l.hlpMinMaxDesc,
            formula: l.hlpMinMaxFormula,
            examples: [l.hlpMinMaxEx1, l.hlpMinMaxEx2],
            tips: [l.hlpMinMaxTip1],
            examplesLabel: l.hlpExamplesLabel,
            tipsLabel: l.hlpTipsLabel,
          ),
          _InfoCard(
            title: l.hlpMeanInequalityTitle,
            icon: Icons.lightbulb,
            content: l.hlpMeanInequalityContent,
          ),
          const SizedBox(height: 16),

          // ============================================================
          // PANEL DE ANÁLISIS
          // ============================================================
          _SectionHeader(title: l.hlpAnalysisPanelHeader, icon: Icons.analytics),
          _InfoCard(
            title: l.hlpAutoAnalysisTitle,
            icon: Icons.auto_awesome,
            content: l.hlpAutoAnalysisContent,
          ),
          const SizedBox(height: 16),

          // ============================================================
          // ALTA PRECISIÓN Y HERRAMIENTAS NUEVAS
          // ============================================================
          _SectionHeader(
              title: l.hlpHighPrecHeader,
              icon: Icons.precision_manufacturing),
          _InfoCard(
            title: l.hlpHighPrecTitle,
            icon: Icons.precision_manufacturing,
            content: l.hlpHighPrecContent,
          ),
          _InfoCard(
            title: l.hlpNewToolsTitle,
            icon: Icons.workspace_premium,
            content: l.hlpNewToolsContent,
          ),
          const SizedBox(height: 16),

          // ============================================================
          // FÓRMULAS CLAVE PARA OLIMPIADAS
          // ============================================================
          _SectionHeader(title: l.hlpOlympiadHeader, icon: Icons.emoji_events),
          _InfoCard(
            title: l.hlpIdentitiesTitle,
            icon: Icons.functions,
            content: l.hlpIdentitiesContent,
          ),
          _InfoCard(
            title: l.hlpRefTableTitle,
            icon: Icons.table_chart,
            content: l.hlpRefTableContent,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// =============================================================================
// WIDGETS AUXILIARES
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta informativa simple (no colapsable)
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 20, color: Theme.of(context).colorScheme.tertiary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta de inicio rápido
class _QuickStartCard extends StatelessWidget {
  final AppLocalizations l;

  const _QuickStartCard({required this.l});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.hlpQuickStartWelcome,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            _buildStep(context, '1', l.hlpQuickStartStep1),
            _buildStep(context, '2', l.hlpQuickStartStep2),
            _buildStep(context, '3', l.hlpQuickStartStep3),
            _buildStep(context, '4', l.hlpQuickStartStep4),
            _buildStep(context, '5', l.hlpQuickStartStep5),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l.hlpQuickStartNote,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
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

  Widget _buildStep(BuildContext context, String number, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta explicativa del sistema de parámetros
class _ParameterSystemCard extends StatelessWidget {
  final AppLocalizations l;

  const _ParameterSystemCard({required this.l});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.hlpParamTypesTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 1 param
            _buildParamType(
              context,
              icon: Icons.looks_one,
              color: Colors.green,
              title: l.hlpParam1Title,
              description: l.hlpParam1Desc,
              example: l.hlpParam1Example,
            ),
            const SizedBox(height: 12),

            // Fixed params
            _buildParamType(
              context,
              icon: Icons.looks_two,
              color: Colors.blue,
              title: l.hlpParam2Title,
              description: l.hlpParam2Desc,
              example: l.hlpParam2Example,
            ),
            const SizedBox(height: 12),

            // Variable params
            _buildParamType(
              context,
              icon: Icons.all_inclusive,
              color: Colors.orange,
              title: l.hlpParamNTitle,
              description: l.hlpParamNDesc,
              example: l.hlpParamNExample,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber,
                          size: 18,
                          color: theme.colorScheme.onTertiaryContainer),
                      const SizedBox(width: 6),
                      Text(
                        l.hlpPendingOpTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.hlpPendingOpDesc,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
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

  Widget _buildParamType(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required String example,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(description, style: theme.textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(
                example,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Sección colapsable con documentación de función
class _CollapsibleSection extends StatelessWidget {
  final String title;
  final String symbol;
  final String params;
  final String description;
  final String formula;
  final List<String> examples;
  final List<String>? tips;
  final String examplesLabel;
  final String tipsLabel;

  const _CollapsibleSection({
    required this.title,
    required this.symbol,
    required this.params,
    required this.description,
    required this.formula,
    required this.examples,
    this.tips,
    required this.examplesLabel,
    required this.tipsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            symbol,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: symbol.length > 4 ? 10 : 13,
            ),
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          params,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
        children: [
          // Descripción
          Align(
            alignment: Alignment.centerLeft,
            child: Text(description, style: theme.textTheme.bodyMedium),
          ),
          const SizedBox(height: 8),

          // Fórmula
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              formula,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Ejemplos
          Align(
            alignment: Alignment.centerLeft,
            child: Text(examplesLabel,
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 2),
          ...examples.map((ex) => Padding(
                padding: const EdgeInsets.only(left: 12, top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('• ', style: theme.textTheme.bodySmall),
                    Expanded(
                        child: Text(ex, style: theme.textTheme.bodySmall)),
                  ],
                ),
              )),

          // Tips opcionales
          if (tips != null && tips!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 14, color: theme.colorScheme.tertiary),
                      const SizedBox(width: 4),
                      Text(tipsLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.tertiary,
                          )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...tips!.map((tip) => Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          '  $tip',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 11,
                            color: theme.colorScheme.onTertiaryContainer,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
