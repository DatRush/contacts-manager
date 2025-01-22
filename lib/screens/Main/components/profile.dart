import 'package:flut1/imports.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode positionFocusNode = FocusNode();

  bool showPositionField = false;

  @override
  void initState() {
    super.initState();
    nameFocusNode.addListener(_handleFocusChange);
    positionFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (nameFocusNode.hasFocus) {
      setState(() {
        showPositionField =
            true; // Показать поле должности при фокусе на поле имени
      });
    } else if (!positionFocusNode.hasFocus && positionController.text.isEmpty) {
      setState(() {
        showPositionField = false; // Скрыть поле, если оно пусто и не в фокусе
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    positionController.dispose();
    nameFocusNode.dispose();
    positionFocusNode.dispose();
    super.dispose();
  }

  Future<void> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List bytes = await pickedFile.readAsBytes();
      // ignore: use_build_context_synchronously
      Provider.of<ContactModel>(context, listen: false)
          .updateImage(bytes); // Обновляем изображение
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Фото
                Center(
                  child: GestureDetector(
                    onTap: () => pickImage(context),
                    child: Consumer<ContactModel>(
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
                ),
                const SizedBox(height: 16),
                const Divider(),
                TextField(
                  controller: nameController,
                  focusNode: nameFocusNode,
                  decoration: const InputDecoration(
                    hintText: 'Введите имя',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
                // Анимация появления поля должности
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                  height: showPositionField ? 60 : 0, // Управляем высотой
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor:
                          showPositionField ? 1.0 : 0.0, // Высота раскрытия
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: TextField(
                          controller: positionController,
                          focusNode: positionFocusNode,
                          decoration: const InputDecoration(
                            hintText: 'Введите должность',
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Био
                TextField(
                  controller: bioController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: 'Введите краткое описание',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  ),
                ),
                const SizedBox(height: 16),
                // Кнопка сохранения
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.save),
                    label: const Text('Сохранить'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: const Icon(Icons.public),
            tooltip: 'Открыть меню',
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
    );
  }
}
