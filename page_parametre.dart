import 'package:flutter/material.dart';

import 'package:tp2_gestion_temps/widget.dart';
import 'package:tp2_gestion_temps/minuteur.dart';
import 'package:shared_preferences/shared_preferences.dart';

//todo: rechercher comment récuperer l'evenement retour
// pour modifier les valeurs du chrono lorsuqu'on appuie sur back

//todo: pouvoir modifier les chiffres quand on inscrit un nombre au clavier

void allerParametres(BuildContext context, Minuteur minuteur) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PageParametres(minuteur_page_acceuil: minuteur),
    ),
  );
}

class PageParametres extends StatefulWidget {
  final Minuteur minuteur_page_acceuil;
  const PageParametres({Key? key, required this.minuteur_page_acceuil})
      : super(key: key);

  @override
  _PageParametresState createState() => _PageParametresState();
}

class _PageParametresState extends State<PageParametres> {
  TextStyle styleTexte = TextStyle(fontSize: 16);

  lireParametres() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? tempsTravail = preferences.getInt(CLE_TEMPS_TRAVAIL);
    if (tempsTravail == null) {
      await preferences.setInt(CLE_TEMPS_TRAVAIL, DEFAULT_TPS_TRAVAIL);
      tempsTravail = preferences.getInt(CLE_TEMPS_TRAVAIL);
    }
    int? tempsPauseCourte = preferences.getInt(CLE_PAUSE_COURTE);
    if (tempsPauseCourte == null) {
      await preferences.setInt(CLE_PAUSE_COURTE, DEFAULT_TPS_PAUSE_COURTE);
      tempsPauseCourte = preferences.getInt(CLE_PAUSE_COURTE);
    }
    int? tempsPauseLongue = preferences.getInt(CLE_PAUSE_LONGUE);
    if (tempsPauseLongue == null) {
      await preferences.setInt(CLE_PAUSE_LONGUE, DEFAULT_TPS_PAUSE_LONGUE);
      tempsPauseLongue = preferences.getInt(CLE_PAUSE_LONGUE);
    }
    setState(() {
      txtTempsTravail.text = tempsTravail.toString();
      txtTempsPauseCourte.text = tempsPauseCourte.toString();
      txtTempsPauseLongue.text = tempsPauseLongue.toString();
    });
  }

  @override
  void initState() {
    lireParametres();
    super.initState();
  }

  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        save_parameter();
        widget.minuteur_page_acceuil.demarrerTravail();
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text('Paramètres'),
          ),
          body: Container(
            child: GridView.count(
              padding: const EdgeInsets.all(20.0),
              scrollDirection: Axis.vertical,
              crossAxisCount: 3,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                Text(
                  'Temps de travail',
                  style: styleTexte,
                ),
                Text(''),
                Text(''),
                BoutonParametre(
                  couleur: Color(0xff455A64),
                  texte: '-',
                  valeur: -1,
                  cle: CLE_TEMPS_TRAVAIL,
                ),
                TextField(
                  controller: txtTempsTravail,
                  style: styleTexte,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                ),
                BoutonParametre(
                  couleur: Color(0xff009688),
                  texte: '+',
                  valeur: 1,
                  cle: CLE_TEMPS_TRAVAIL,
                ),
                Text(
                  'Temps pour une pause courte',
                  style: styleTexte,
                ),
                Text(''),
                Text(''),
                BoutonParametre(
                  couleur: Color(0xff455A64),
                  texte: '-',
                  valeur: -1,
                  cle: CLE_PAUSE_COURTE,
                ),
                TextField(
                  controller: txtTempsPauseCourte,
                  style: styleTexte,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                ),
                BoutonParametre(
                  couleur: Color(0xff009688),
                  texte: '+',
                  valeur: 1,
                  cle: CLE_PAUSE_COURTE,
                ),
                Text(
                  'Temps pour une pause longue',
                  style: styleTexte,
                ),
                Text(''),
                Text(''),
                BoutonParametre(
                  couleur: Color(0xff455A64),
                  texte: '-',
                  valeur: -1,
                  cle: CLE_PAUSE_LONGUE,
                ),
                TextField(
                  controller: txtTempsPauseLongue,
                  style: styleTexte,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                ),
                BoutonParametre(
                  couleur: Color(0xff009688),
                  texte: '+',
                  valeur: 1,
                  cle: CLE_PAUSE_LONGUE,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
