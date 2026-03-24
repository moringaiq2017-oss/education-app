import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/theme.dart';
import 'splash_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final child = authProvider.currentChild;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // الهيدر
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Text(
                        child?.name.substring(0, 1).toUpperCase() ?? '👤',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF667EEA),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      child?.name ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${child?.age ?? 0} سنوات',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              // القائمة
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text(
                        'الإعدادات',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // إعدادات الحساب
                      _buildSection(
                        title: 'الحساب',
                        items: [
                          _SettingsItem(
                            icon: Icons.person_outline,
                            title: 'تعديل الملف الشخصي',
                            onTap: () {
                              _showEditProfile(context);
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.devices,
                            title: 'معلومات الجهاز',
                            subtitle: 'ID: ${child?.deviceId.substring(0, 8) ?? ""}...',
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // إعدادات التطبيق
                      _buildSection(
                        title: 'التطبيق',
                        items: [
                          _SettingsItem(
                            icon: Icons.notifications_outlined,
                            title: 'الإشعارات',
                            trailing: Switch(
                              value: true,
                              onChanged: (value) {
                                // TODO: تفعيل/تعطيل الإشعارات
                              },
                              activeColor: AppTheme.primaryColor,
                            ),
                          ),
                          _SettingsItem(
                            icon: Icons.volume_up_outlined,
                            title: 'الأصوات',
                            trailing: Switch(
                              value: true,
                              onChanged: (value) {
                                // TODO: تفعيل/تعطيل الأصوات
                              },
                              activeColor: AppTheme.primaryColor,
                            ),
                          ),
                          _SettingsItem(
                            icon: Icons.download_outlined,
                            title: 'التحميل التلقائي',
                            subtitle: 'تحميل الفيديوهات عند الاتصال بالواي فاي',
                            trailing: Switch(
                              value: false,
                              onChanged: (value) {
                                // TODO: التحميل التلقائي
                              },
                              activeColor: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // حول التطبيق
                      _buildSection(
                        title: 'حول',
                        items: [
                          _SettingsItem(
                            icon: Icons.info_outline,
                            title: 'عن التطبيق',
                            subtitle: 'الإصدار 1.0.0',
                            onTap: () {
                              _showAboutDialog(context);
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.help_outline,
                            title: 'المساعدة والدعم',
                            onTap: () {
                              // TODO: صفحة المساعدة
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.privacy_tip_outlined,
                            title: 'سياسة الخصوصية',
                            onTap: () {
                              // TODO: صفحة سياسة الخصوصية
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // البيانات
                      _buildSection(
                        title: 'البيانات',
                        items: [
                          _SettingsItem(
                            icon: Icons.sync,
                            title: 'مزامنة البيانات',
                            onTap: () async {
                              await authProvider.refreshChildData();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('تم تحديث البيانات'),
                                    backgroundColor: AppTheme.successColor,
                                  ),
                                );
                              }
                            },
                          ),
                          _SettingsItem(
                            icon: Icons.storage_outlined,
                            title: 'مساحة التخزين المستخدمة',
                            subtitle: 'حوالي 45 ميجابايت',
                            onTap: () {},
                          ),
                          _SettingsItem(
                            icon: Icons.delete_outline,
                            title: 'مسح الذاكرة المؤقتة',
                            onTap: () {
                              _showClearCacheDialog(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // زر تسجيل الخروج
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () => _showLogoutDialog(context),
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: items.map((item) {
              final isLast = items.last == item;
              return Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: AppTheme.primaryColor),
                    title: Text(item.title),
                    subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
                    trailing: item.trailing ??
                        const Icon(Icons.arrow_back_ios, size: 16),
                    onTap: item.onTap,
                  ),
                  if (!isLast)
                    Divider(height: 1, indent: 56, color: Colors.grey[300]),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showEditProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تعديل الملف الشخصي'),
        content: const Text('هذه الميزة ستكون متاحة قريباً'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('عن التطبيق'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('🎓', style: TextStyle(fontSize: 60)),
            SizedBox(height: 16),
            Text(
              'تعليم الأطفال',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('الإصدار 1.0.0'),
            SizedBox(height: 16),
            Text(
              'تطبيق تعليمي تفاعلي للأطفال العراقيين',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('مسح الذاكرة المؤقتة'),
        content: const Text('هل أنت متأكد من مسح الذاكرة المؤقتة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم مسح الذاكرة المؤقتة')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
}
