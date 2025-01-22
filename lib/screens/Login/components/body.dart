import 'package:flut1/screens/Login/components/background.dart';
import 'package:flut1/screens/Register/register_screen.dart';
import 'package:flut1/screens/Main/mainpage.dart';
import 'package:flut1/imports.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final authProvider = Provider.of<AuthModel>(context);

    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'LOGIN',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          SvgPicture.asset(
            'assets/pictures/placeholder.svg',
            height: size.height * 0.3,
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          RoundedInputField(
            icon: Icons.mail,
            hintText: 'Email',
            onChanged: (value) {
              authProvider.setEmail(value);
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              authProvider.setPassword(value);
            },
          ),
          RoundedButton(
            text: 'LOGIN',
            color: const Color.fromARGB(180, 4, 221, 236),
            press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const MyHomePage();
                    },
                  ),
                );
            },
          ),
          // Кнопка для входа
          // RoundedButton(
          //   text: authProvider.isLoading ? 'LOADING...' : 'LOGIN',
          //   color: const Color.fromARGB(180, 4, 221, 236),
          //   press: authProvider.isLoading ? null : () async {
          //     bool success = await authProvider.login();

          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text(success ? 'Вход прошел успешно' : authProvider.errorMessage ?? 'Ошибка')),
          //     );

          //     if (success) {
          //       authProvider.clearError(); // Сброс ошибок перед переходом
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) {
          //             return const MyHomePage();
          //           },
          //         ),
          //       );
          //     }
          //   },
          // ),
          SizedBox(
            height: size.height * 0.03,
          ),
          AlreadyHAACheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const RegisterScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
