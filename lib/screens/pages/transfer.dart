import 'package:flutter/material.dart';
import 'package:my_pocket_wallet/classes/reusable_widgets.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  int _currentPage = 0;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  String recipientName = '';
  String amount = '';
  bool isProcessing = false;

  @override
  void dispose() {
    _searchController.dispose();
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _next() {
    setState(() {
      if (_currentPage < 2) _currentPage++;
    });
  }

  void _back() {
    setState(() {
      if (_currentPage > 0) _currentPage--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        title: const Text(
          "Transfer Money",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
        leading: _currentPage > 0
            ? IconButton(
                onPressed: _back,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              )
            : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _buildPage(_currentPage),
      ),
    );
  }

  Widget _buildPage(int i) {
    switch (i) {
      case 0:
        return _searchPage();
      case 1:
        return _confirmPage();
      case 2:
        return _successPage();
      default:
        return const Center(child: Text("Invalid Page"));
    }
  }

  Widget _searchPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleText("Transfer money to"),
          const SizedBox(height: 10),
          const SubTitleText("Enter name, phone number, or account number"),
          const SizedBox(height: 18),
          CustomInputField(
            label: "Recipient Name / Phone / Account",
            controller: _searchController,
          ),
          const SizedBox(height: 16),
          CustomInputField(
            label: "Enter Amount",
            controller: _amountController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 25),
          CustomButton(
            title: "Continue",
            onPressed: () {
              if (_searchController.text.isEmpty ||
                  _amountController.text.isEmpty) {
                showError(context, "Please fill all fields");
                return;
              }

              setState(() {
                recipientName = _searchController.text;
                amount = "₦${_amountController.text}";
              });

              _next();
            },
          ),
        ],
      ),
    );
  }

  Widget _confirmPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleText("Confirm Transfer"),
          const SizedBox(height: 20),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orangeAccent,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              recipientName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Amount: $amount",
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 20),
          CustomInputField(
            label: "Enter PIN",
            controller: _pinController,
            obscure: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 25),
          CustomButton(
            title: "Confirm Transfer",
            loading: isProcessing,
            onPressed: () {
              if (_pinController.text.length < 4) {
                showError(context, "Invalid PIN");
                return;
              }

              _next();
            },
          ),
        ],
      ),
    );
  }

  Widget _successPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
          const SizedBox(height: 20),
          Text(
            "Success! $amount sent to $recipientName",
            style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          CustomButton(
            title: "Done",
            onPressed: () {
              setState(() {
                _currentPage = 0;
                _searchController.clear();
                _amountController.clear();
                _pinController.clear();
              });
            },
          ),
        ],
      ),
    );
  }
}
