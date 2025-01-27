import 'package:flut1/imports.dart';
import 'package:flut1/screens/Login/login_screen.dart';
import 'package:flut1/screens/Main/mainpage.dart';
import 'package:flut1/screens/Register/components/ordivider.dart';
import 'package:flut1/screens/Register/components/socalicon.dart';
import 'package:flut1/screens/Register/components/background.dart';



class Body extends StatelessWidget {
  const Body({super.key});
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthModel>(context); 
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'REGISTER',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.03),
          RoundedInputField(
            hintText: 'Username',
            onChanged: (value) {
              authProvider.setUsername(value); 
            },
          ),
          RoundedInputField(
            hintText: 'Email',
            icon: Icons.mail,
            onChanged: (value) {
              authProvider.setEmail(value);
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              authProvider.setPassword(value);
            },
          ),
          if (authProvider.validateMessage != null)
            Text(
              authProvider.validateMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          RoundedButton(
            text: authProvider.isLoading ? 'LOADING...' : 'REGISTER',
            color: const Color.fromARGB(180, 4, 221, 236),
            press: authProvider.isLoading ? null : () async {
              bool success = await authProvider.signUp();

              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(success ? 'Регистрация прошла успешно' : authProvider.errorMessage ?? 'Ошибка')),
              );

              if (success) {
                authProvider.clearError(); 
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const MyHomePage();
                    },
                  ),
                );
              }
            },
          ),
          SizedBox(height: size.height * 0.03),
          AlreadyHAACheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
          const OrDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocalIcon(iconsrc: 'assets/pictures/google.svg', press: () {}),
              SocalIcon(iconsrc: 'assets/pictures/facebook.svg', press: () {}),
              SocalIcon(iconsrc: 'assets/pictures/x.svg', press: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
