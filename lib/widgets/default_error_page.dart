import 'package:flutter/material.dart';
import 'package:miru_anime/app_theme/app_colors.dart';

class DefaultErrorPage extends StatelessWidget {
  final String error;
  const DefaultErrorPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      children: [
        Text(
          'Si è verificato un errore.'
            '\nControlla se il tuo dispositivo è connesso ad internet.',
          style: Theme.of(context).textTheme.bodySmall!.apply(
            color: AppColors.teal,
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
        Text(
          "Se l'app ancora non funziona molto probabilmente ciò "
              'è dovuto al fatto che la struttura del sito (animeworld.tv) è ' 'cambiata o il sito stesso non è al momento raggiungibile '
              '(in questo caso riprova più tardi).',
          style: Theme.of(context).textTheme.bodySmall!.apply(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 20)),
        Text(
            'Se puoi, crea un issue su GitHub e manda questo messaggio di errore ' 'così aggiorneremo il codice il prima possibile:',
          style: Theme.of(context).textTheme.bodySmall!.apply(
            color: Theme.of(context).colorScheme.onSurface
          ),
        ),
        const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        Text(
          error,
          style: Theme.of(context).textTheme.bodySmall!.apply(
            color: AppColors.functionalred
          ),
        )
      ],
    );
  }
}
