import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="todo"
export default class extends Controller {
  static targets = ["list", "incomplete", "complete"]

  connect() {
    this.subscription = consumer.subscriptions.create("TodoChannel", {
      received: this.updateTodos.bind(this)
    })
  }

  disconnect() {
    this.subscription.unsubscribe()
  }

  updateTodos(data) {
    const isAtIncompleteTab = this.incompleteTarget.classList.contains("border-blue-600");
    const todos = isAtIncompleteTab ? data.incomplete : data.complete;
    this.listTarget.innerHTML = todos;
  }
}
