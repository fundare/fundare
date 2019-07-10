import React, { Component } from 'react';
import { Stitch, RemoteMongoClient } from "mongodb-stitch-react-native-sdk";

import {
 RefreshControl,
 Platform,
 SectionList,
 StyleSheet,
 Text,
 View,
 Image,
 TextInput,
 TouchableOpacity
} from 'react-native';

const background = require("./logo.png");
const lockIcon = require("./lock.png");
const personIcon = require("./person.png");

export default class LoginScreen extends React.Component {

 handleSubmit = () => {
  Keyboard.dismiss();
  const stitchAppClient = Stitch.defaultAppClient;
  const mongoClient = stitchAppClient.getServiceClient(
   RemoteMongoClient.factory,
   "mongodb-atlas"
  );
  const db = mongoClient.db("fundare");
  const users = db.collection("users");
  if (this.email.text === RegExp("[a-zA-Z0-9]*\@[a-zA-Z0-9]*\.[a-zA-Z0-9]{2,3}")) {
   users
    .insertOne({ //insert record
     accountid: 0,
     userid: 0,
     email: this.email.text,
     username: this.email.text,
     password: this.password.text,
     date: new Date()
    })
    .then(() => { //reset fields to blank
     this.setState({ value: !this.email.value });
     this.setState({ value: !this.password.value });
     this.setState({ email: "" });
     this.setState({ password: "" });
    })
    .catch(err => {
     console.warn(err);
    });
  } else {
   //render error message
  }
 };

 render() {
  return (
   <View style={styles.container}>
    <Image
     style={[styles.background, styles.container]}
     source={background}
     resizeMode="cover"
    />
    <View style={styles.container} />
    <View style={styles.wrapper}>
     <View style={styles.inputWrap}>
      <View style={styles.iconWrap}>
       <Image
        source={personIcon}
        style={styles.icon}
        resizeMode="contain"
       />
      </View>
      <TextInput
       placeholder="Email"
       style={styles.input}
       underlineColorAndroid="transparent"
       onChangeText={text => this.setState({ text })}
       value={this.email.text}
       onSubmitEditing={() => this.handleSubmit()}
      />
     </View>
     <View style={styles.inputWrap}>
      <View style={styles.iconWrap}>
       <Image
        source={lockIcon}
        style={styles.icon}
        resizeMode="contain"
       />
      </View>
      <TextInput
       placeholder="Password"
       secureTextEntry
       style={styles.input}
       underlineColorAndroid="transparent"
       onChangeText={text => this.setState({ text })}
       value={this.password.text}
       onSubmitEditing={() => this.handleSubmit()}
      />
     </View>
     <TouchableOpacity activeOpacity={.5}>
      <View style={styles.button}>
       <Text style={styles.buttonText}>Sign In</Text>
      </View>
     </TouchableOpacity>
     <TouchableOpacity activeOpacity={.5}>
      <View>
       <Text style={styles.forgotPasswordText}>Forgot Password?</Text>
      </View>
     </TouchableOpacity>
    </View>
    <View style={styles.container} />
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
 inputWrap: {
  flexDirection: "row",
  marginVertical: 10,
  height: 40,
  backgroundColor: "transparent"
 },
 input: {
  flex: 1,
  paddingHorizontal: 10,
  backgroundColor: '#FFF'
 },
 iconWrap: {
  paddingHorizontal: 7,
  alignItems: "center",
  justifyContent: "center",
  backgroundColor: "#000"
 },
 icon: {
  width: 20,
  height: 20,
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
 },
 forgotPasswordText: {
  color: "#FFF",
  backgroundColor: "transparent",
  textAlign: "center"
 }
});

AppRegistry.registerComponent('LoginScreen', () => LoginScreen);
