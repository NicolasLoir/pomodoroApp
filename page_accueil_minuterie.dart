import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:tp2_gestion_temps/widget.dart';
import 'package:tp2_gestion_temps/minuteur.dart';
import 'package:tp2_gestion_temps/page_parametre.dart';

const double PADDING_BETWEEN_BUTTON = 5.0;
const double MIN_WIDTH = 20.0;
Minuteur minuteur = Minuteur();

class PageAccueilMinuterie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> elementsMenu = [];
    elementsMenu.add(PopupMenuItem(
      value: 'Paramètres',
      child: Text('Paramètres'),
    ));
    minuteur.demarrerTravail();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Ma gestion du temps'),
        actions: <Widget>[
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return elementsMenu.toList();
          }, onSelected: (s) {
            if (s == 'Paramètres') {
              allerParametres(context, minuteur);
            }
          }),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints contraints) {
          final double largeurDisponible = contraints.maxWidth;

          return Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(PADDING_BETWEEN_BUTTON),
                  ),
                  Expanded(
                    child: BoutonGenerique(
                      couleur: Color(0xff009688),
                      texte: 'Travail',
                      taille: MIN_WIDTH,
                      action: () => minuteur.demarrerTravail(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(PADDING_BETWEEN_BUTTON),
                  ),
                  Expanded(
                    child: BoutonGenerique(
                      couleur: Color(0xff607D8B),
                      texte: 'Mini pause',
                      taille: MIN_WIDTH,
                      action: () => minuteur.demarrerMiniPause(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(PADDING_BETWEEN_BUTTON),
                  ),
                  Expanded(
                    child: BoutonGenerique(
                      couleur: Color(0xff455A64),
                      texte: 'Maxi pause',
                      taille: MIN_WIDTH,
                      action: () => minuteur.demarrerMaxiPause(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(PADDING_BETWEEN_BUTTON),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  initialData: ModeleMinuteur('00:00', 1),
                  stream: minuteur.stream(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    ModeleMinuteur modele_minuteur = snapshot.data;
                    return Container(
                      child: CircularPercentIndicator(
                        radius: largeurDisponible / 2,
                        lineWidth: 10.0,
                        percent: modele_minuteur.pourcentage,
                        center: Text(
                          modele_minuteur.temps,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        progressColor: Color(0xff009688),
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(PADDING_BETWEEN_BUTTON),
                  ),
                  Expanded(
                    child: BoutonGenerique(
                      couleur: Color(0xff212121),
                      texte: 'Arrêter',
                      taille: 20.0,
                      action: () => minuteur.arretMinuteur(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(PADDING_BETWEEN_BUTTON),
                  ),
                  Expanded(
                    child: BoutonGenerique(
                      couleur: Color(0xff009688),
                      texte: 'Relancer',
                      taille: 20.0,
                      action: () => minuteur.relancerMinuteur(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(PADDING_BETWEEN_BUTTON),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
