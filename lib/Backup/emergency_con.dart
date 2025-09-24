import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ai_women_safety/data/models/emergency_contact.dart';
import 'package:ai_women_safety/data/services/emergency_contact_service.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});
  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController, _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(child: _buildContactsList()),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildHeader() => Container(
    margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE53E3E), Color(0xFFC53030)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.emergency, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Emergency Contacts",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Add up to 5 emergency contacts",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE53E3E).withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE53E3E).withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFFE53E3E),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "These contacts will be notified during emergencies and can access your location when needed.",
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFFE53E3E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildContactsList() {
    return StreamBuilder<List<EmergencyContact>>(
      stream: EmergencyContactService.getEmergencyContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        final contacts = snapshot.data ?? [];
        if (contacts.isEmpty) return _buildEmptyState();
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: contacts.length,
          itemBuilder: (context, index) => _buildContactCard(contacts[index]),
        );
      },
    );
  }

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.contacts_outlined, color: Colors.white, size: 64),
        SizedBox(height: 24),
        Text(
          "No Emergency Contacts",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Add your first emergency contact to get started",
          style: TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  Widget _buildContactCard(EmergencyContact contact) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.95),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.all(20),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor:
            contact.isPrimary
                ? const Color(0xFFE53E3E)
                : const Color(0xFF9C27B0),
        child: Icon(
          contact.isPrimary ? Icons.star : Icons.person,
          color: Colors.white,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              contact.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          if (contact.isPrimary)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE53E3E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "PRIMARY",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE53E3E),
                ),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            EmergencyContactService.formatPhoneNumber(contact.phoneNumber),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (contact.relationship != null && contact.relationship!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                contact.relationship!,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Color(0xFF9C27B0)),
        onSelected: (value) => _handleMenuAction(value, contact),
        itemBuilder:
            (context) => [
              if (!contact.isPrimary)
                const PopupMenuItem(
                  value: 'set_primary',
                  child: ListTile(
                    leading: Icon(Icons.star, color: Color(0xFFE53E3E)),
                    title: Text('Set as Primary'),
                  ),
                ),
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit, color: Color(0xFF9C27B0)),
                  title: Text('Edit'),
                ),
              ),
              const PopupMenuItem(
                value: 'call',
                child: ListTile(
                  leading: Icon(Icons.phone, color: Color(0xFF4CAF50)),
                  title: Text('Call'),
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Color(0xFFE53E3E)),
                  title: Text('Delete'),
                ),
              ),
            ],
      ),
    ),
  );

  Widget _buildAddButton() => FloatingActionButton(
    onPressed: _showAddContactDialog,
    backgroundColor: const Color(0xFF9C27B0),
    child: const Icon(Icons.add, color: Colors.white, size: 28),
  );

  void _handleMenuAction(String action, EmergencyContact contact) {
    switch (action) {
      case 'set_primary':
        _setPrimaryContact(contact);
        break;
      case 'edit':
        _showEditContactDialog(contact);
        break;
      case 'call':
        _callContact(contact);
        break;
      case 'delete':
        _deleteContact(contact);
        break;
    }
  }

  void _setPrimaryContact(EmergencyContact contact) async {
    try {
      await EmergencyContactService.setPrimaryContact(contact.id);
      _showSnackBar('${contact.name} set as primary contact', Colors.green);
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  void _callContact(EmergencyContact contact) {
    _showSnackBar('Calling ${contact.name}...', Colors.blue);
  }

  void _deleteContact(EmergencyContact contact) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: const [
                Icon(Icons.warning, color: Colors.red, size: 28),
                SizedBox(width: 12),
                Text("Delete Contact", style: TextStyle(color: Colors.red)),
              ],
            ),
            content: Text(
              "Are you sure you want to delete ${contact.name} from your emergency contacts?",
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await EmergencyContactService.deleteEmergencyContact(
                      contact.id,
                    );
                    _showSnackBar(
                      '${contact.name} deleted successfully',
                      Colors.green,
                    );
                  } catch (e) {
                    _showSnackBar('Error: $e', Colors.red);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showAddContactDialog() => _showContactDialog();
  void _showEditContactDialog(EmergencyContact contact) =>
      _showContactDialog(contact: contact);

  void _showContactDialog({EmergencyContact? contact}) {
    final isEditing = contact != null;
    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController = TextEditingController(
      text: contact?.phoneNumber ?? '',
    );
    final relationshipController = TextEditingController(
      text: contact?.relationship ?? '',
    );
    bool isPrimary = contact?.isPrimary ?? false;
    String phoneNumber = contact?.phoneNumber ?? '';

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      Icon(
                        isEditing ? Icons.edit : Icons.add,
                        color: const Color(0xFF9C27B0),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isEditing ? "Edit Contact" : "Add Contact",
                        style: const TextStyle(color: Color(0xFF2D3748)),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            hintText: "Enter full name",
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color(0xFF9C27B0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF9C27B0),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        IntlPhoneField(
                          initialValue: phoneNumber,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            hintText: "Enter phone number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF9C27B0),
                                width: 2,
                              ),
                            ),
                          ),
                          initialCountryCode: 'IN',
                          // countryFilter: const ['IN'], // restrict to India only
                          onChanged:
                              (phone) => phoneNumber = phone.completeNumber,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: relationshipController,
                          decoration: InputDecoration(
                            labelText: "Relationship (Optional)",
                            hintText: "e.g., Mom, Dad, Best Friend",
                            prefixIcon: const Icon(
                              Icons.favorite,
                              color: Color(0xFF9C27B0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF9C27B0),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (!isEditing)
                          SwitchListTile(
                            title: const Text(
                              "Set as Primary Contact",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: const Text(
                              "This contact will be notified first",
                            ),
                            value: isPrimary,
                            onChanged:
                                (value) =>
                                    setDialogState(() => isPrimary = value),
                            activeColor: const Color(0xFFE53E3E),
                            contentPadding: EdgeInsets.zero,
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.trim().isEmpty ||
                            phoneNumber.trim().isEmpty) {
                          _showSnackBar(
                            'Please fill in all required fields',
                            Colors.red,
                          );
                          return;
                        }
                        if (!EmergencyContactService.isValidPhoneNumber(
                          phoneNumber,
                        )) {
                          _showSnackBar(
                            'Please enter a valid phone number',
                            Colors.red,
                          );
                          return;
                        }
                        Navigator.pop(context);
                        try {
                          final newContact = EmergencyContact(
                            id: contact?.id ?? '',
                            name: nameController.text.trim(),
                            phoneNumber: phoneNumber,
                            relationship:
                                relationshipController.text.trim().isEmpty
                                    ? null
                                    : relationshipController.text.trim(),
                            isPrimary: isPrimary,
                            createdAt: contact?.createdAt ?? DateTime.now(),
                            updatedAt: DateTime.now(),
                          );
                          if (isEditing) {
                            await EmergencyContactService.updateEmergencyContact(
                              contact!.id,
                              newContact,
                            );
                            _showSnackBar(
                              'Contact updated successfully',
                              Colors.green,
                            );
                          } else {
                            await EmergencyContactService.addEmergencyContact(
                              newContact,
                            );
                            _showSnackBar(
                              'Contact added successfully',
                              Colors.green,
                            );
                          }
                        } catch (e) {
                          _showSnackBar('Error: $e', Colors.red);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9C27B0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEditing ? "Update" : "Add",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
