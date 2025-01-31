import 'package:flut1/imports.dart';

class ProfileWidget extends StatefulWidget {
  final CardData cardData;
  final bool isOwner;

  const ProfileWidget(
      {required this.cardData, required this.isOwner, super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController positionController = TextEditingController();
  late TextEditingController companyNameController = TextEditingController();
  late TextEditingController companyaddressController = TextEditingController();
  late TextEditingController ownerController = TextEditingController();

  final apiService = ApiService('http://10.201.5.216:8080/api');

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode positionFocusNode = FocusNode();
  final FocusNode companyNameFocusNode = FocusNode();
  final FocusNode ownerFocusNode = FocusNode();

  bool showPositionField = false;
  bool showOwnerField = false;
  bool isCompanyView = false; // Переменная для переключения между видами

  @override
  void initState() {
    super.initState();
    nameFocusNode.addListener(_handleFocusChange);
    positionFocusNode.addListener(_handleFocusChange);
    companyNameFocusNode.addListener(_handleCompanyFocusChange);
    ownerFocusNode.addListener(_handleCompanyFocusChange);
    nameController = TextEditingController(text: widget.cardData.name);
    descriptionController = TextEditingController(text: widget.cardData.description);
    positionController = TextEditingController(text: widget.cardData.position);
    companyNameController =
        TextEditingController(text: widget.cardData.company_name);
    companyaddressController = TextEditingController(text: widget.cardData.company_address);
  }

  void _handleFocusChange() {
    setState(() {
      showPositionField = nameFocusNode.hasFocus || positionFocusNode.hasFocus;
    });
  }

  void _handleCompanyFocusChange() {
    setState(() {
      showOwnerField = companyNameFocusNode.hasFocus || ownerFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    positionController.dispose();
    companyNameController.dispose();
    companyaddressController.dispose();
    ownerController.dispose();
    nameFocusNode.dispose();
    positionFocusNode.dispose();
    companyNameFocusNode.dispose();
    ownerFocusNode.dispose();
    super.dispose();
  }

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      Provider.of<AuthModel>(context, listen: false)
          .updateImage(bytes); // Обновляем изображение
    } 
  }

  void _saveChanges() async {
    final updatedCard = CardData(
      id: widget.cardData.id,
      name: nameController.text,
      description: descriptionController.text,
      position: positionController.text,
      company_name: companyNameController.text,
      company_address: companyaddressController.text,
      user_id: widget.cardData.user_id,
      avatar_url: '',
    );

    try {
      await apiService.updateCard(widget.cardData.id, updatedCard);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Изменения сохранены')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка сохранения: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              child: isCompanyView ? _buildCompanyCard() : _buildProfileCard(),
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: Icon(
              isCompanyView ? Icons.person : Icons.business,
              size: 30,
            ),
            tooltip: 'Переключить вид',
            onPressed: () {
              setState(() {
                isCompanyView = !isCompanyView;
              });
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FloatingActionButton(
              onPressed: _saveChanges,
              tooltip: 'Сохранить',
              child: const Icon(Icons.save),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Column(
      key: const ValueKey('profileCard'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfilePicture(),
        const SizedBox(height: 16),
        TextField(
          controller: nameController,
          focusNode: nameFocusNode,
          enabled: widget.isOwner,
          decoration: const InputDecoration(
            hintText: 'Введите имя',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate,
          height: showPositionField ? 60 : 0,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: showPositionField ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  controller: positionController,
                  focusNode: positionFocusNode,
                  enabled: widget.isOwner,
                  decoration: const InputDecoration(
                    hintText: 'Введите должность',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          maxLines: 2,
          enabled: widget.isOwner,
          decoration: const InputDecoration(
            hintText: 'Введите краткое описание',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyCard() {
    return Column(
      key: const ValueKey('companyCard'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfilePicture(),
        const SizedBox(height: 16),
        TextField(
          controller: companyNameController,
          focusNode: companyNameFocusNode,
          enabled: widget.isOwner,
          decoration: const InputDecoration(
            hintText: 'Введите название компании',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.decelerate,
          height: showOwnerField ? 60 : 0,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: showOwnerField ? 1.0 : 0.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  controller: ownerController,
                  focusNode: ownerFocusNode,
                  enabled: widget.isOwner,
                  decoration: const InputDecoration(
                    hintText: 'Введите имя владельца',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
        TextField(
          controller: companyaddressController,
          enabled: widget.isOwner,
          decoration: const InputDecoration(
            hintText: 'Введите адрес',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildProfilePicture() {
    return Center(
      child: GestureDetector(
        onTap: () => pickImage(context),
        child: Consumer<AuthModel>(
          builder: (context, model, child) {
            return Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                image: model.imageBytes != null
                    ? DecorationImage(
                        image: MemoryImage(model.imageBytes!),
                        fit: BoxFit.cover,
                      )
                    : null,
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(75),
              ),
              child: model.imageBytes == null
                  ? const Center(
                      child: Icon(Icons.person, size: 50),
                    )
                  : null,
            );
          },
        ),
      ),
    );
  }
}
