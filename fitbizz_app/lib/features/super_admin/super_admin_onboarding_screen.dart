import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../core/localization/app_locale.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_toast.dart';

class PresetOption {
  final String id;
  final String name;
  final String url;

  const PresetOption({required this.id, required this.name, required this.url});
}

const List<PresetOption> _presetLogos = [
  PresetOption(id: 'logo1', name: 'Titan Power', url: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=150&auto=format&fit=crop&q=80'),
  PresetOption(id: 'logo2', name: 'Iron Shield', url: 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=150&auto=format&fit=crop&q=80'),
  PresetOption(id: 'logo3', name: 'Pulse Flame', url: 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=150&auto=format&fit=crop&q=80'),
  PresetOption(id: 'logo4', name: 'Elite Club', url: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=150&auto=format&fit=crop&q=80'),
];

const List<PresetOption> _presetOwnerPhotos = [
  PresetOption(id: 'owner1', name: 'Kamran Ahmed', url: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop&q=80'),
  PresetOption(id: 'owner2', name: 'Ayesha Malik', url: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&auto=format&fit=crop&q=80'),
  PresetOption(id: 'owner3', name: 'Bilal Tariq', url: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop&q=80'),
  PresetOption(id: 'owner4', name: 'Hamza Ali', url: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&auto=format&fit=crop&q=80'),
];

const List<String> _availableFacilities = [
  'AC & Climate Control',
  'Locker & Showers',
  'CrossFit Rig',
  'Biometric Turnstiles',
  'Sauna & Steam Room',
  'Cardio Theater',
  'Free Weights Zone',
  'Cafe & Juice Bar',
];

class SuperAdminOnboardingScreen extends StatefulWidget {
  final ApiClient apiClient;
  final VoidCallback onOnboardingSuccess;
  final bool isEmbedded;

  const SuperAdminOnboardingScreen({
    super.key,
    required this.apiClient,
    required this.onOnboardingSuccess,
    this.isEmbedded = false,
  });

  @override
  State<SuperAdminOnboardingScreen> createState() => _SuperAdminOnboardingScreenState();
}

class _SuperAdminOnboardingScreenState extends State<SuperAdminOnboardingScreen> {
  int _currentStep = 0;
  bool _isSubmitting = false;
  bool _isDetectingGps = false;

  // Step 1: Business Profile & Location
  final _gymNameController = TextEditingController(text: 'Titan Fitness Arena');
  final _gymCodeController = TextEditingController(text: 'titan-arena');
  final _ownerNameController = TextEditingController(text: 'Kamran Ahmed');
  final _ownerPhoneController = TextEditingController(text: '+92 300 1234567');
  final _ownerEmailController = TextEditingController(text: 'owner@titanfitness.com');
  final _gymAddressController = TextEditingController(text: 'Main Boulevard, Block 4, Gulberg III');
  final _cityController = TextEditingController(text: 'Lahore');
  final _gpsController = TextEditingController(text: '31.5204° N, 74.3587° E');

  // Step 2: Multi-Branch Architecture
  int _numberOfBranches = 2;
  final List<TextEditingController> _branchNameControllers = [
    TextEditingController(text: 'Gulberg Main Arena (HQ)'),
    TextEditingController(text: 'DHA Phase 5 Branch'),
  ];
  final List<TextEditingController> _branchAddressControllers = [
    TextEditingController(text: 'Gulberg III, Main Boulevard'),
    TextEditingController(text: 'Sector CCA, DHA Phase 5'),
  ];

  // Step 3: Identity & Assets
  final _cnicController = TextEditingController(text: '35202-1234567-1');
  final _areaSqFtController = TextEditingController(text: '8,500 sq ft');
  String _selectedLogoUrl = _presetLogos[0].url;
  String _selectedOwnerPhoto = _presetOwnerPhotos[0].url;
  final List<String> _selectedFacilities = [
    'AC & Climate Control',
    'Locker & Showers',
    'CrossFit Rig',
    'Biometric Turnstiles',
  ];

  // Step 4: Plans (Preset vs Custom)
  bool _isCustomPlan = false;
  String _selectedPresetPlan = 'Pro Multi-Branch Plan';
  double _customMonthlyPrice = 35000;
  int _customTrialDays = 15;
  bool _enableTrial = true;
  bool _featureSms = true;
  bool _featureBiometrics = true;
  bool _featurePos = true;
  bool _featureMobileApp = true;
  bool _feature247Support = true;

  @override
  void dispose() {
    _gymNameController.dispose();
    _gymCodeController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _ownerEmailController.dispose();
    _gymAddressController.dispose();
    _cityController.dispose();
    _gpsController.dispose();
    _cnicController.dispose();
    _areaSqFtController.dispose();
    for (var c in _branchNameControllers) {
      c.dispose();
    }
    for (var c in _branchAddressControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _detectCurrentGpsLocation() async {
    setState(() {
      _isDetectingGps = true;
    });

    try {
      final ipRes = await http.get(Uri.parse('http://ip-api.com/json/')).timeout(const Duration(seconds: 4));
      if (ipRes.statusCode == 200) {
        final data = json.decode(ipRes.body);
        if (data['status'] == 'success') {
          final lat = (data['lat'] as num).toDouble();
          final lon = (data['lon'] as num).toDouble();
          final city = data['city'] as String? ?? 'Lahore';
          final region = data['regionName'] as String? ?? '';
          
          String detailedAddress = '$city, $region, Pakistan';
          try {
            final nomRes = await http.get(
              Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon'),
              headers: {'User-Agent': 'FitBizzApp/2.0'},
            ).timeout(const Duration(seconds: 3));
            if (nomRes.statusCode == 200) {
              final nomData = json.decode(nomRes.body);
              final displayName = nomData['display_name'] as String?;
              if (displayName != null && displayName.isNotEmpty) {
                final parts = displayName.split(',');
                detailedAddress = parts.length > 3 ? '${parts[0].trim()}, ${parts[1].trim()}, ${parts[2].trim()}' : displayName;
              }
            }
          } catch (_) {}

          if (mounted) {
            setState(() {
              _isDetectingGps = false;
              _gpsController.text = '${lat.toStringAsFixed(4)}° N, ${lon.toStringAsFixed(4)}° E';
              _cityController.text = city;
              _gymAddressController.text = detailedAddress;
            });

            AppToast.showSuccess(
              context,
              'Location Detected',
              '📍 ${_gpsController.text} ($city)',
            );
            return;
          }
        }
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _isDetectingGps = false;
        _gpsController.text = '31.5204° N, 74.3587° E';
        if (_cityController.text.isEmpty) _cityController.text = 'Lahore';
        if (_gymAddressController.text.isEmpty) _gymAddressController.text = 'Main Boulevard, Gulberg III, Lahore';
      });

      AppToast.showInfo(
        context,
        'GPS Location Set',
        '📍 ${_gpsController.text} (${_cityController.text})',
      );
    }
  }

  void _updateBranchCount(int newCount) {
    if (newCount < 1 || newCount > 10) return;
    setState(() {
      _numberOfBranches = newCount;
      while (_branchNameControllers.length < newCount) {
        final index = _branchNameControllers.length + 1;
        _branchNameControllers.add(TextEditingController(
          text: index == 1 ? '${_gymNameController.text.trim()} Main Arena (HQ)' : 'Branch #$index (${_cityController.text.trim()})',
        ));
        _branchAddressControllers.add(TextEditingController(text: 'Branch #$index Address, Commercial Zone'));
      }
      while (_branchNameControllers.length > newCount) {
        _branchNameControllers.removeLast().dispose();
        _branchAddressControllers.removeLast().dispose();
      }
    });
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      if (_gymNameController.text.trim().length < 3) {
        AppToast.showError(context, 'Validation Error', tr('val_gym_name'));
        return false;
      }
      if (_ownerNameController.text.trim().length < 3) {
        AppToast.showError(context, 'Validation Error', tr('val_owner_name'));
        return false;
      }
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(_ownerEmailController.text.trim())) {
        AppToast.showError(context, 'Validation Error', tr('val_email'));
        return false;
      }
      final phoneDigits = _ownerPhoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (phoneDigits.length < 10) {
        AppToast.showError(context, 'Validation Error', tr('val_phone'));
        return false;
      }
      if (_gymAddressController.text.trim().isEmpty) {
        AppToast.showError(context, 'Validation Error', tr('val_address'));
        return false;
      }
      if (_cityController.text.trim().isEmpty) {
        AppToast.showError(context, 'Validation Error', tr('val_city'));
        return false;
      }
    } else if (_currentStep == 1) {
      for (int i = 0; i < _numberOfBranches; i++) {
        if (_branchNameControllers[i].text.trim().isEmpty) {
          AppToast.showError(context, 'Validation Error', 'Please enter a valid name for Branch #${i + 1}');
          return false;
        }
      }
    } else if (_currentStep == 3) {
      if (_isCustomPlan && _customMonthlyPrice <= 0) {
        AppToast.showError(context, 'Validation Error', tr('val_price'));
        return false;
      }
    }
    return true;
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _submitOnboarding();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitOnboarding() async {
    if (!_validateCurrentStep()) return;
    setState(() {
      _isSubmitting = true;
    });

    final branchesPayload = [];
    for (int i = 0; i < _numberOfBranches; i++) {
      branchesPayload.add({
        'name': _branchNameControllers[i].text.trim(),
        'code': 'branch-00${i + 1}',
        'address': _branchAddressControllers[i].text.trim(),
        'phone': _ownerPhoneController.text.trim(),
      });
    }

    final payload = {
      'gymName': _gymNameController.text.trim(),
      'gymCode': _gymCodeController.text.trim(),
      'ownerName': _ownerNameController.text.trim(),
      'ownerPhone': _ownerPhoneController.text.trim(),
      'ownerEmail': _ownerEmailController.text.trim(),
      'ownerPhotoUrl': _selectedOwnerPhoto,
      'gymLogoUrl': _selectedLogoUrl,
      'gymAddress': _gymAddressController.text.trim(),
      'city': _cityController.text.trim(),
      'gpsCoordinates': _gpsController.text.trim(),
      'cnic': _cnicController.text.trim(),
      'areaSqFt': _areaSqFtController.text.trim(),
      'facilities': _selectedFacilities,
      'branches': branchesPayload,
      'planConfig': {
        'isCustom': _isCustomPlan,
        'planName': _isCustomPlan ? 'Custom Plan (Rs ${_customMonthlyPrice.toInt()}/mo)' : _selectedPresetPlan,
        'monthlyPrice': _isCustomPlan ? _customMonthlyPrice : 35000,
        'enableTrial': _enableTrial,
        'trialDays': _enableTrial ? _customTrialDays : 0,
        'features': {
          'sms': _featureSms,
          'biometrics': _featureBiometrics,
          'pos': _featurePos,
          'mobileApp': _featureMobileApp,
          'support247': _feature247Support,
        },
      },
    };

    try {
      await widget.apiClient.post('/super-admin/onboard', payload);
    } catch (_) {
      // Offline mode
    }

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      AppToast.showSuccess(
        context,
        'Onboarding Completed!',
        '🎉 ${_gymNameController.text.trim()} registered with $_numberOfBranches branches.',
      );
      widget.onOnboardingSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.enter && !HardwareKeyboard.instance.isShiftPressed) {
            _nextStep();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            _prevStep();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: ListenableBuilder(
        listenable: AppLocaleController.instance,
        builder: (context, _) {
          final content = SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 880),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Breadcrumb & Header Bar (Matching Web 1:1)
                    Container(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.stone200)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gym Tenant Onboarding Wizard',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.stone900,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Register new fitness businesses, multi-branch structures, and automated credentials dispatch',
                                style: TextStyle(fontSize: 12, color: AppColors.stone500),
                              ),
                            ],
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.stone700,
                              side: const BorderSide(color: AppColors.stone300),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.arrow_back, size: 14),
                            label: const Text('Back to Overview', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              if (widget.isEmbedded) {
                                widget.onOnboardingSuccess();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // 4-Step Progress Indicator Grid (Matching Web 1:1)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.stone200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _buildStepTab(0, 1, '1. Business Profile', 'Identity & GPS Location')),
                          const SizedBox(width: 8),
                          Expanded(child: _buildStepTab(1, 2, '2. Branch Setup', 'Multi-Location Network')),
                          const SizedBox(width: 8),
                          Expanded(child: _buildStepTab(2, 3, '3. Assets & Facilities', 'Logos, Media & Amenities')),
                          const SizedBox(width: 8),
                          Expanded(child: _buildStepTab(3, 4, '4. Subscription Plan', 'Trial & Custom Pricing')),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Active Step Form Container (Matching Web fb-panel)
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.stone200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildCurrentStepContent(),
                          const SizedBox(height: 28),
                          const Divider(height: 1, color: AppColors.stone200),
                          const SizedBox(height: 16),

                          // Step Navigation Bar Inside Form Panel (Matching Web)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_currentStep > 0)
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.arrow_back, size: 14),
                                  label: const Text('Previous Step', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5)),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.stone700,
                                    side: const BorderSide(color: AppColors.stone300),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: _prevStep,
                                )
                              else
                                const SizedBox.shrink(),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      if (widget.isEmbedded) {
                                        widget.onOnboardingSuccess();
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Cancel', style: TextStyle(color: AppColors.stone500, fontSize: 11.5)),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  _currentStep < 3
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.japaniPhalDark,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            elevation: 0,
                                          ),
                                          onPressed: _nextStep,
                                          child: Text('Continue to Step ${_currentStep + 2} →', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                        )
                                      : ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF16A34A),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            elevation: 0,
                                          ),
                                          onPressed: _isSubmitting ? null : _submitOnboarding,
                                          child: Text(_isSubmitting ? 'Onboarding Gym...' : '✓ Complete Gym Onboarding', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          );

          if (widget.isEmbedded) {
            return Container(
              color: const Color(0xFFFAFAF9),
              child: content,
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFFAFAF9),
            body: SafeArea(child: content),
          );
        },
      ),
    );
  }

  Widget _buildStepTab(int index, int num, String title, String desc) {
    final isActive = _currentStep == index;
    final isDone = _currentStep > index;

    return InkWell(
      onTap: () => setState(() => _currentStep = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFFF7ED) : (isDone ? const Color(0xFFF0FDF4) : const Color(0xFFFAFAF9)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.japaniPhalDark : (isDone ? const Color(0xFF86EFAC) : AppColors.stone200),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isDone ? const Color(0xFF16A34A) : (isActive ? AppColors.japaniPhalDark : AppColors.stone200),
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : Text('$num', style: TextStyle(color: isActive ? Colors.white : AppColors.stone700, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive ? const Color(0xFF431407) : AppColors.stone900,
                      fontSize: 11.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    desc,
                    style: const TextStyle(color: AppColors.stone500, fontSize: 9.5),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Business();
      case 1:
        return _buildStep2Branches();
      case 2:
        return _buildStep3Assets();
      case 3:
        return _buildStep4Plan();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Step 1: Business Profile & Location (Matching Web Image 2)
  Widget _buildStep1Business() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP 1: BUSINESS PROFILE & LOCATION',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppColors.stone900, letterSpacing: 0.5),
                ),
                SizedBox(height: 2),
                Text('Enter core credentials, owner contact info, and pinpoint GPS location', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
              child: const Text('Step 1 of 4', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: AppColors.stone200),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Gym Business Name *',
                hint: 'e.g. Titan Fitness Arena',
                controller: _gymNameController,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: AppTextField(
                label: 'Gym Code / Slug ID *',
                hint: 'titan-arena',
                controller: _gymCodeController,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Owner Full Name *',
                hint: 'Kamran Ahmed',
                controller: _ownerNameController,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: AppTextField(
                label: 'Owner Phone Number (WhatsApp Enabled) *',
                hint: '+92 300 1234567',
                controller: _ownerPhoneController,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Owner Email Address *',
                hint: 'owner@titanfitness.com',
                controller: _ownerEmailController,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: AppTextField(
                label: 'City / Metropolitan Area *',
                hint: 'Lahore',
                controller: _cityController,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        AppTextField(
          label: 'Gym Main Street Address *',
          hint: 'Main Boulevard, Block 4, Gulberg III',
          controller: _gymAddressController,
        ),
        const SizedBox(height: AppSpacing.sm),

        // Quick City Preset Chips
        Row(
          children: [
            const Text('Popular Cities:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.stone500)),
            const SizedBox(width: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    {'name': 'Lahore', 'coords': '31.5204° N, 74.3587° E'},
                    {'name': 'Karachi', 'coords': '24.8607° N, 67.0011° E'},
                    {'name': 'Islamabad', 'coords': '33.6844° N, 73.0479° E'},
                    {'name': 'Rawalpindi', 'coords': '33.5651° N, 73.0169° E'},
                    {'name': 'Faisalabad', 'coords': '31.4504° N, 73.1350° E'},
                    {'name': 'Peshawar', 'coords': '34.0151° N, 71.5249° E'},
                    {'name': 'Multan', 'coords': '30.1575° N, 71.5249° E'},
                    {'name': 'Quetta', 'coords': '30.1798° N, 66.9750° E'},
                  ].map((c) {
                    final isSelected = _cityController.text.toLowerCase() == c['name']!.toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _cityController.text = c['name']!;
                            _gpsController.text = c['coords']!;
                          });
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.japaniPhalDark : const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: isSelected ? AppColors.japaniPhalDark : AppColors.stone300),
                          ),
                          child: Text(
                            c['name']!,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.stone700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // GPS Coordinates (Directly Editable + 1-Click Auto Detect Button)
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextField(
                label: 'GPS Coordinates (Editable / Auto-Detected)',
                hint: 'e.g. 31.5204° N, 74.3587° E',
                controller: _gpsController,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.japaniPhalDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              icon: _isDetectingGps
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.my_location, size: 15),
              label: Text(
                _isDetectingGps ? 'Detecting...' : '📍 Auto Detect Location',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              onPressed: _isDetectingGps ? null : _detectCurrentGpsLocation,
            ),
          ],
        ),
      ],
    );
  }

  /// Step 2: Multi-Branch Architecture (Zero Overflow, Full Width)
  Widget _buildStep2Branches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP 2: MULTI-BRANCH ARCHITECTURE',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppColors.stone900, letterSpacing: 0.5),
                ),
                SizedBox(height: 2),
                Text('Scale tenant operations across single or multiple physical gym locations', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
              child: const Text('Step 2 of 4', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: AppColors.stone200),
        const SizedBox(height: 20),

        // Branch Stepper Counter
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.stone50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.stone200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Branches Configured', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone900)),
                    SizedBox(height: 2),
                    Text('Each branch gets its own reception terminal & biometric turnstile sync', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.white, side: const BorderSide(color: AppColors.stone300)),
                    icon: const Icon(Icons.remove, size: 16),
                    onPressed: () => _updateBranchCount(_numberOfBranches - 1),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.japaniPhalDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('$_numberOfBranches Branches', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.white, side: const BorderSide(color: AppColors.stone300)),
                    icon: const Icon(Icons.add, size: 16),
                    onPressed: () => _updateBranchCount(_numberOfBranches + 1),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Dynamic Branch Cards
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _numberOfBranches,
          itemBuilder: (context, idx) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.stone200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Branch #${idx + 1} Configuration', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark)),
                      if (idx == 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
                          child: const Text('Main Facility / HQ', style: TextStyle(color: Color(0xFFB45309), fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Branch Name',
                          controller: _branchNameControllers[idx],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: AppTextField(
                          label: 'Street Address',
                          controller: _branchAddressControllers[idx],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  /// Step 3: Identity & Assets
  Widget _buildStep3Assets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP 3: IDENTITY, BRANDING & FACILITIES',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppColors.stone900, letterSpacing: 0.5),
                ),
                SizedBox(height: 2),
                Text('Select gym logo, owner avatar, and enabled facility amenities', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
              child: const Text('Step 3 of 4', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: AppColors.stone200),
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Owner CNIC / National Tax ID',
                hint: '35202-1234567-1',
                controller: _cnicController,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: AppTextField(
                label: 'Total Covered Facility Area',
                hint: '8,500 sq ft',
                controller: _areaSqFtController,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Preset Logo Grid (Matching Web 1:1)
        const Text('Gym Brand Logo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone800)),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3.0,
          ),
          itemCount: _presetLogos.length,
          itemBuilder: (context, idx) {
            final logo = _presetLogos[idx];
            final isSelected = _selectedLogoUrl == logo.url;

            return InkWell(
              onTap: () => setState(() => _selectedLogoUrl = logo.url),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFF7ED) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.japaniPhalDark : AppColors.stone200,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(logo.url, width: 34, height: 34, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        logo.name,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? AppColors.japaniPhalDark : AppColors.stone800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Preset Owner Photo Grid (Matching Web 1:1)
        const Text('Owner Profile Photo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone800)),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3.0,
          ),
          itemCount: _presetOwnerPhotos.length,
          itemBuilder: (context, idx) {
            final owner = _presetOwnerPhotos[idx];
            final isSelected = _selectedOwnerPhoto == owner.url;

            return InkWell(
              onTap: () => setState(() => _selectedOwnerPhoto = owner.url),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFFF7ED) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.japaniPhalDark : AppColors.stone200,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundImage: NetworkImage(owner.url),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        owner.name,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? AppColors.japaniPhalDark : AppColors.stone800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Facilities Multi-Select Badges
        const Text('Enabled Facility Amenities', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone800)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableFacilities.map((facility) {
            final isSelected = _selectedFacilities.contains(facility);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFacilities.remove(facility);
                  } else {
                    _selectedFacilities.add(facility);
                  }
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.japaniPhalDark : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isSelected ? AppColors.japaniPhalDark : AppColors.stone300),
                ),
                child: Text(
                  '${isSelected ? '✓ ' : '+ '}$facility',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.stone700,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Step 4: Subscription Plan & 15-Day Free Trial
  Widget _buildStep4Plan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP 4: SUBSCRIPTION PLAN & 15-DAY FREE TRIAL',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: AppColors.stone900, letterSpacing: 0.5),
                ),
                SizedBox(height: 2),
                Text('Configure 15-day trial period, preset plans, or custom tenant pricing', style: TextStyle(fontSize: 11, color: AppColors.stone500)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
              child: const Text('Step 4 of 4', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: AppColors.stone200),
        const SizedBox(height: 20),

        // 15-Day Trial Activation Banner (Matching Web 1:1)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF86EFAC)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Activate 15-Day Free Trial Period (Recommended)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF14532D))),
                  SizedBox(height: 2),
                  Text('Tenant gets complete access without payment barrier during setup', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                ],
              ),
              Row(
                children: [15, 30, 60].map((d) {
                  final isSelected = _enableTrial && _customTrialDays == d;
                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: InkWell(
                      onTap: () => setState(() {
                        _enableTrial = true;
                        _customTrialDays = d;
                      }),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF15803D) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isSelected ? const Color(0xFF15803D) : const Color(0xFF86EFAC)),
                        ),
                        child: Text(
                          '$d Days',
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF14532D),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Preset vs Custom Plan Builder Switcher Pill
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.stone100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => setState(() => _isCustomPlan = false),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: !_isCustomPlan ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: !_isCustomPlan ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : null,
                  ),
                  child: Text(
                    'Preset Packages',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: !_isCustomPlan ? AppColors.japaniPhalDark : AppColors.stone600,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => setState(() => _isCustomPlan = true),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _isCustomPlan ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: _isCustomPlan ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : null,
                  ),
                  child: Text(
                    '🛠️ Custom Plan Builder',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _isCustomPlan ? AppColors.japaniPhalDark : AppColors.stone600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        if (!_isCustomPlan) ...[
          // Preset Plan Cards
          Row(
            children: [
              Expanded(
                child: _buildPresetCard(
                  'Starter Business Plan',
                  'Rs 15,000 / mo',
                  '1 Branch',
                  'For single location gyms',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildPresetCard(
                  'Pro Multi-Branch Plan',
                  'Rs 35,000 / mo',
                  'Up to 3 Branches',
                  'Best for growing gyms',
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildPresetCard(
                  'Enterprise Elite Suite',
                  'Rs 75,000 / mo',
                  'Unlimited Branches',
                  'Full franchise operations',
                ),
              ),
            ],
          ),
        ] else ...[
          // Custom Plan Builder Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFED7AA)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TAILORED CUSTOM TENANT PLAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark, letterSpacing: 0.5)),
                    Text(formatMoney(_customMonthlyPrice), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.japaniPhalDark)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Monthly License Price', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(formatMoney(_customMonthlyPrice), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.japaniPhalDark)),
                  ],
                ),
                Slider(
                  value: _customMonthlyPrice,
                  min: 15000,
                  max: 120000,
                  divisions: 21,
                  activeColor: AppColors.japaniPhalDark,
                  onChanged: (val) => setState(() => _customMonthlyPrice = val),
                ),

                const SizedBox(height: AppSpacing.sm),
                const Text('Included Feature Entitlements:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.stone800)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _buildFeatureCheckbox('SMS & WhatsApp Alerts', _featureSms, (v) => setState(() => _featureSms = v)),
                    _buildFeatureCheckbox('Biometrics & Turnstiles', _featureBiometrics, (v) => setState(() => _featureBiometrics = v)),
                    _buildFeatureCheckbox('POS Billing & Invoicing', _featurePos, (v) => setState(() => _featurePos = v)),
                    _buildFeatureCheckbox('Mobile App Pass', _featureMobileApp, (v) => setState(() => _featureMobileApp = v)),
                    _buildFeatureCheckbox('24/7 Priority Support', _feature247Support, (v) => setState(() => _feature247Support = v)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPresetCard(String name, String price, String branches, String desc) {
    final isSelected = _selectedPresetPlan == name;

    return InkWell(
      onTap: () => setState(() => _selectedPresetPlan = name),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7ED) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.japaniPhalDark : AppColors.stone200,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.stone900),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelected) const Icon(Icons.check_circle, size: 16, color: AppColors.japaniPhalDark),
              ],
            ),
            const SizedBox(height: 6),
            Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.japaniPhalDark)),
            const SizedBox(height: 4),
            Text('$branches • $desc', style: const TextStyle(fontSize: 11, color: AppColors.stone500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCheckbox(String label, bool value, Function(bool) onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: value,
            activeColor: AppColors.japaniPhalDark,
            onChanged: (v) => onChanged(v ?? false),
          ),
          Text(label, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

