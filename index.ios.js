import React, { Component } from 'react';

import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Image,
  TouchableOpacity
} from 'react-native';

const background = require("./logo.png");

export default class WelcomeScreen extends Component {

  render() {
    return (
      <View style={styles.container}>
        <Image
          style={[styles.background, styles.container]}
          source={background}
          resizeMode="cover"
        />
        <View style={styles.wrapper}>
          <View style={styles.selectionWrap}>
            <View style={styles.loginWrap}>
              <TouchableOpacity activeOpacity={.5}>
                <View style={styles.button}>
                  <Text style={styles.buttonText}>Login</Text>
                </View>
              </TouchableOpacity>
            </View>
            <View style={styles.selectionWrap}>
              <View style={styles.loginWrap}>
                <TouchableOpacity activeOpacity={.5}>
                  <View style={styles.button}>
                    <Text style={styles.buttonText}>Register</Text>
                  </View>
                </TouchableOpacity>
              </View>
            </View>
          </View>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  background: {
    width: null,
    height: null
  },
  wrapper: {
    paddingHorizontal: 15,
    marginVertical: 1
  },
  selectionWrap: {
    flexDirection: "row",
    marginVertical: 10,
    height: 40,
    backgroundColor: "transparent"
  },
  loginWrap: {
    paddingHorizontal: 7,
    alignItems: "center",
    justifyContent: "center",
    backgroundColor: "#000"
  },
  button: {
    backgroundColor: "#000",
    paddingVertical: 15,
    marginVertical: 15,
    alignItems: "center",
    justifyContent: "center"
  },
  buttonText: {
    color: "#FFF",
    fontSize: 18
  }
});

AppRegistry.registerComponent('WelcomeScreen', () => WelcomeScreen);
