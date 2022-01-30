import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final int DEFAULT_TPS_TRAVAIL = 30;
final int DEFAULT_TPS_PAUSE_COURTE = 5;
final int DEFAULT_TPS_PAUSE_LONGUE = 20;

class BoutonGenerique extends StatelessWidget {
  final Color couleur;
  final String texte;
  final double taille;
  final VoidCallback action;
  const BoutonGenerique({
    Key? key,
    required this.couleur,
    required this.texte,
    required this.taille,
    required this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        this.texte,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: this.action,
      color: this.couleur,
      minWidth: this.taille,
    );
  }
}

class BoutonParametre extends StatelessWidget {
  final Color couleur;
  final String texte;
  final int valeur;
  final String cle;

  BoutonParametre({
    Key? key,
    required this.couleur,
    required this.texte,
    required this.valeur,
    required this.cle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text(
        this.texte,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () => _changeValue(this.cle, this.valeur),
      color: this.couleur,
    );
  }

  void _changeValue(String cle, int valeur) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? nouveau_temp;

    switch (cle) {
      case CLE_TEMPS_TRAVAIL:
        nouveau_temp = int.parse(txtTempsTravail.text) + valeur;
        txtTempsTravail.text = (nouveau_temp).toString();
        break;
      case CLE_PAUSE_COURTE:
        nouveau_temp = int.parse(txtTempsPauseCourte.text) + valeur;
        txtTempsPauseCourte.text = nouveau_temp.toString();
        break;
      case CLE_PAUSE_LONGUE:
        nouveau_temp = int.parse(txtTempsPauseLongue.text) + valeur;
        txtTempsPauseLongue.text = nouveau_temp.toString();
        break;
    }

    await preferences.setInt(cle, nouveau_temp!);
  }
}

save_parameter() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setInt(CLE_TEMPS_TRAVAIL, int.parse(txtTempsTravail.text));
  await preferences.setInt(
      CLE_PAUSE_COURTE, int.parse(txtTempsPauseCourte.text));
  await preferences.setInt(
      CLE_PAUSE_LONGUE, int.parse(txtTempsPauseLongue.text));
}

const String CLE_TEMPS_TRAVAIL = 'Temps de travail';
const String CLE_PAUSE_COURTE = 'Pause courte';
const String CLE_PAUSE_LONGUE = 'Pause longue';

TextEditingController txtTempsTravail = TextEditingController();
TextEditingController txtTempsPauseCourte = TextEditingController();
TextEditingController txtTempsPauseLongue = TextEditingController();
