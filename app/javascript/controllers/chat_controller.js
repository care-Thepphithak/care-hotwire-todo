import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ["messages", "msgInput", "error", "userName", "noMsg"];

  connect() {
    console.log("Connected to chat controller");
    this.chatChannel = consumer.subscriptions.create("ChatChannel", {
      received: this.displayMessage.bind(this),
    });
  }

  disconnect() {
    this.chatChannel.unsubscribe()
    console.log("Disconnected from chat controller");
  }

  sendMessage() {
    const message = this.msgInputTarget.value;
    const userName = this.userNameTarget.value.length === 0 ? "Anonymous" : this.userNameTarget.value;
    console.log(message);
    if (message.length > 0) {
      console.log("Sending message...");
      this.chatChannel.send({ date: new Date(Date.now()).toLocaleString(), userName: userName, message: message });
      this.msgInputTarget.value = "";
      this.errorTarget.textContent = "";
      console.log("Message sent");
    } else {
      console.log("Message is empty");
      this.errorTarget.textContent = "Message cannot be empty";
    }
  }

  handleFocus() {
    console.log("Handling focus...");
    this.msgInputTarget.placeholder = this.userNameTarget.value.length === 0 ? "Sending as anonymous" : `Sending as ${this.userNameTarget.value}`;
  }

  handleUnfocus() {
    console.log("Handling unfocus...");
    this.msgInputTarget.placeholder = "Type your message here...";
  }

  handleUserNameChange() {
    console.log("Handling user name change...");
  }

  removeError() {
    if (this.errorTarget.textContent.length > 0) {
      console.log("Removing error");
      this.errorTarget.textContent = "";
    }
  }

  displayMessage(data) {
    console.log(data);
    this.noMsgTarget.textContent = "";
    console.log("Displaying message...");
    
    const messageContainer = document.createElement("div");
    const dateElement = document.createElement("span");
    const userNameElement = document.createElement("span");
    const messageElement = document.createElement("p");
    messageElement.id = "chat-msgs";
    messageContainer.style.marginBottom = "10px";
    dateElement.style.color = "gray";

    userNameElement.textContent = `${data.userName}  ·  `;
    dateElement.textContent = `${data.date}`;
    messageElement.textContent = data.message;

    messageContainer.appendChild(userNameElement);
    messageContainer.appendChild(dateElement);
    messageContainer.appendChild(messageElement);

    this.messagesTarget.appendChild(messageContainer);
  }
}
