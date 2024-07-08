import 'package:flutter/material.dart';
import 'package:try1/graph1.dart';
import 'package:try1/graph2.dart';
import 'package:try1/graph3.dart';
import 'package:try1/graph4.dart';
import 'package:try1/pulmonaryfunctiontest.dart';
import 'package:try1/sixminutewalk.dart';
import 'package:try1/stopbang.dart';

class Formdoc extends StatelessWidget {
  final String id;

  const Formdoc({
    required this.id,
    Key? key,
  }) : super(key: key);

  get userId => id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Form',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan.shade300, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1.0],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: 300.0,
          height: 500.0,
          margin: EdgeInsets.only(top: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              colors: [Colors.cyan.shade300, Colors.grey.shade200],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 1.0],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFormButton(
                context,
                'STOP-BANG SLEEP APNEA QUESTIONNAIRE',
                Graph1(id: id),
              ),
              _buildFormButton(
                context,
                'EPSWORTH SLEEPINESS SCORE(ESS)',
                Graph2(id: id),
              ),
              _buildFormButton(
                context,
                'MODIFIED MEDICAL RESEARCH COUNCIL DYSPNOEA SCALE',
                Graph3(id: id),
              ),
              _buildFormButton(
                context,
                'MODIFIED BORG DYSPNEA SCALE',
                Graph4(id: id),
              ),
              _buildFormButton(
                context,
                'SIX MINUTE WALK TEST WORKSHEET',
                Sixminute(id: id),
              ),
              _buildFormButton(
                context,
                'PULMONARY FUNCTION TEST',
                pulmonary(id: id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormButton(BuildContext context, String text, Widget destination) {
    return Container(
      height: 50,
      width: 280,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
