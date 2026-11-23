import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PSLocale.dart';
import 'PSPayoutValidation.dart';
import 'ps_LocalProvider.dart';
import 'ps_extension_help.dart';
import 'ps_text.dart';
import 'ps_img.dart';

class PSPaymentSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  const PSPaymentSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final methods = PSLocale.current.payments;
        final columns = methods.length == 1 ? 1 : 2;
        final width = methods.length == 1
            ? min(157.0, constraints.maxWidth)
            : (constraints.maxWidth - 12 * (columns - 1)) / columns;
        return Wrap(
          alignment: methods.length == 1
              ? WrapAlignment.center
              : WrapAlignment.start,
          spacing: 12,
          runSpacing: 12,
          children: [
            for (var i = 0; i < methods.length; i++)
              SizedBox(
                width: width,
                height: width * 174 / 459,
                child: OutlinedButton(
                  onPressed: () => onChanged(i),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: PSLocale.paymentAsset(i) != null
                      ? Image.asset(
                          PSLocale.paymentAsset(
                            i,
                            variant: selected == i ? 'selected' : 'normal',
                          )!.image(),
                          fit: BoxFit.contain,
                        )
                      : FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            methods[i],
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// 两个提现入口共用表单；只有确认成功后才保存账号与渠道。
class PSPayoutForm extends StatefulWidget {
  final VoidCallback onConfirmed;
  final bool fullScreen;
  const PSPayoutForm({
    super.key,
    required this.onConfirmed,
    this.fullScreen = false,
  });
  @override
  State<PSPayoutForm> createState() => _PSPayoutFormState();
}

class _PSPayoutFormState extends State<PSPayoutForm> {
  final _account = TextEditingController();
  final _name = TextEditingController();
  final _cpf = TextEditingController();
  final Set<String> _errors = {};
  int _selected = 0;
  String _type = 'Email';
  bool _saving = false;
  String get _method => PSLocale.payment(_selected);
  bool get _pix => _method == 'Pix';
  bool get _ready =>
      _account.text.trim().isNotEmpty &&
      (!_pix || (_name.text.trim().isNotEmpty && _cpf.text.trim().isNotEmpty));

  @override
  void initState() {
    super.initState();
    _selected = PSLocale.paymentIndex(
      PSLocalProvider.instance.ps_tx_ing_account,
    );
    for (final controller in [_account, _name, _cpf]) {
      controller.addListener(_changed);
    }
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final controller in [_account, _name, _cpf]) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _field(
    String label,
    TextEditingController controller,
    String id, {
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        onChanged: (_) => setState(() => _errors.remove(id)),
        decoration: InputDecoration(
          labelText: PSLocale.tr(label),
          errorText: _errors.contains(id)
              ? PSLocale.tr('The format you entered is incorrect.')
              : null,
          errorMaxLines: 3,
          filled: true,
          fillColor: const Color(0xFFF0F8FA),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_ready || _saving) return;
    final error = PSPayoutValidation.validate(
      _method,
      _account.text,
      name: _name.text,
      cpf: _cpf.text,
      type: _type,
    );
    if (error != null) {
      var id = 'account';
      var controller = _account;
      if (_pix && !RegExp(r'^\d{11}$').hasMatch(_cpf.text.trim())) {
        id = 'cpf';
        controller = _cpf;
      } else if (_pix &&
          (_name.text.trim().isEmpty || _name.text.contains('@'))) {
        id = 'name';
        controller = _name;
      }
      controller.clear();
      setState(() => _errors.add(id));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(PSLocale.tr(error))));
      return;
    }
    setState(() => _saving = true);
    final provider = PSLocalProvider.instance;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ps_payout_country', PSLocale.current.country);
    await prefs.setString('ps_payout_method', _method);
    await prefs.setString('ps_payout_name', _name.text.trim());
    await prefs.setString('ps_payout_cpf', _cpf.text.trim());
    await prefs.setString('ps_payout_type', _type);
    await provider.updateString(
      provider.ps_account_idName,
      _account.text.trim(),
    );
    await provider.updateint(provider.ps_tx_ing_accountName, _selected);
    await provider.updateint(provider.ps_account_seled_indexName, _selected);
    if (mounted) widget.onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final form = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: PSText(
                  text: PSLocale.tr('Confirm Payment Information'),
                  size: 20,
                  color: const Color(0xFF264077),
                  weight: FontWeight.w900,
                  maxLines: 2,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  tooltip: MaterialLocalizations.of(context).closeButtonLabel,
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          PSText(
            text: PSLocale.tr('Payment Method:'),
            size: 16,
            color: const Color(0xFF264077),
            weight: FontWeight.w900,
          ),
          const SizedBox(height: 12),
          PSPaymentSelector(
            selected: _selected,
            onChanged: (value) => setState(() {
              _selected = value;
              _errors.clear();
              _account.clear();
              _name.clear();
              _cpf.clear();
            }),
          ),
          if (_pix) ...[
            _field('CPF', _cpf, 'cpf', keyboard: TextInputType.number),
            _field('Name', _name, 'name', keyboard: TextInputType.name),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: DropdownButtonFormField<String>(
                initialValue: _type,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: PSLocale.tr('Account Type:'),
                ),
                items: ['Email', 'Phone', 'CPF', 'EVP']
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(PSLocale.tr(type)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() {
                  _type = value!;
                  _account.clear();
                  _errors.remove('account');
                }),
              ),
            ),
          ],
          _field(
            _pix ? _type : 'Account',
            _account,
            'account',
            keyboard: _method == 'PagBank' || (_pix && _type == 'Email')
                ? TextInputType.emailAddress
                : TextInputType.text,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: Color(0xFF566D7E),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  PSLocale.tr('Safe & Secure'),
                  style: const TextStyle(color: Color(0xFF566D7E)),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            PSLocale.tr('We’ll only use this for sending your withdrawal'),
            style: const TextStyle(color: Color(0xFF566D7E)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _ready && !_saving ? _submit : null,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0E79C6),
              minimumSize: const Size.fromHeight(50),
            ),
            child: Text(PSLocale.tr('Confirm'), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
    return Scaffold(
      backgroundColor: widget.fullScreen
          ? const Color(0xFFD6ECFF)
          : Colors.transparent,
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: widget.fullScreen ? PSDImg('ps_tx_infos_bg') : null,
        ),
        child: SafeArea(
          child: SizedBox.expand(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 375),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5FAFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: form,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
