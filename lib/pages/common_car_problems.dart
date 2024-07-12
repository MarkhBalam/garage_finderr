import 'package:flutter/material.dart';

class CommonCarProblemsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Common Car Problems'),
        backgroundColor: Colors.blue, // AppBar color set to blue
      ),
      body: ListView(
        children: [
          ProblemTile(
            title: 'Flat Tire',
            subtitle: 'Instructions for changing a flat tire.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FlatTirePage()),
              );
            },
          ),
          ProblemTile(
            title: 'Dead Battery',
            subtitle: 'Instructions for jump-starting a car.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeadBatteryPage()),
              );
            },
          ),
          ProblemTile(
            title: 'Replace Air Filter',
            subtitle: 'Instructions for replacing the air filter.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AirFilterPage()),
              );
            },
          ),
          ProblemTile(
            title: 'Wiper Blade Replacement',
            subtitle: 'Instructions for replacing wiper blades.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WiperBladePage()),
              );
            },
          ),
          ProblemTile(
            title: 'Check and Top Up Fluids',
            subtitle: 'Instructions for checking and topping up car fluids.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FluidsPage()),
              );
            },
          ),
          ProblemTile(
            title: 'Headlight Replacement',
            subtitle: 'Instructions for replacing headlights.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HeadlightPage()),
              );
            },
          ),
          ProblemTile(
            title: 'Clean Battery Terminals',
            subtitle: 'Instructions for cleaning battery terminals.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BatteryTerminalsPage()),
              );
            },
          ),
          ProblemTile(
            title: 'Check Tire Pressure',
            subtitle: 'Instructions for checking and adjusting tire pressure.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TirePressurePage()),
              );
            },
          ),
          ProblemTile(
            title: 'Replace Fuse',
            subtitle: 'Instructions for replacing a blown fuse.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FusePage()),
              );
            },
          ),
          ProblemTile(
            title: 'Adjust Headlights',
            subtitle: 'Instructions for adjusting your headlights.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HeadlightsAdjustmentPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProblemTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ProblemTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      leading: Icon(Icons.build, color: Colors.blue), // Build icon for problems
      onTap: onTap,
    );
  }
}

class FlatTirePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Fix a Flat Tire'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Detailed instructions for fixing a flat tire.'),
      ),
    );
  }
}

class DeadBatteryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Jump-Start a Dead Battery'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Detailed instructions for jump-starting a car.'),
      ),
    );
  }
}

class AirFilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Replace an Air Filter'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Detailed instructions for replacing the air filter.'),
      ),
    );
  }
}

class WiperBladePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Replace Wiper Blades'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Detailed instructions for replacing wiper blades.'),
      ),
    );
  }
}

class FluidsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Check and Top Up Fluids'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
            'Detailed instructions for checking and topping up car fluids.'),
      ),
    );
  }
}

class HeadlightPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Replace Headlights'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Detailed instructions for replacing headlights.'),
      ),
    );
  }
}

class BatteryTerminalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Clean Battery Terminals'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Detailed instructions for cleaning battery terminals.'),
      ),
    );
  }
}

class TirePressurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Check Tire Pressure'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
            'Detailed instructions for checking and adjusting tire pressure.'),
      ),
    );
  }
}

class FusePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Replace a Fuse'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Detailed instructions for replacing a blown fuse.'),
      ),
    );
  }
}

class HeadlightsAdjustmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to Adjust Headlights'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Detailed instructions for adjusting your headlights.'),
      ),
    );
  }
}
