import consumer from "./consumer";

consumer.subscriptions.create("DispatcherChannel", {
  // Вызывается единожды при создании подписки.
  initialized() {
    this.update = this.update.bind(this)
  },

  // Вызывается, когда подписка готова на сервере для использования.
  connected() {
    this.install()
    this.update()
  },

  // Вызывается, когда закрывается соединения WebSocket.
  disconnected() {
    this.uninstall()
  },

  // Вызывается, когда подписка отвергается сервером.
  rejected() {
    this.uninstall()
  },

  update() {
    this.documentIsActive ? this.appear() : this.away()
  },

  appear() {
    // Вызывает `AppearanceChannel#appear(data)` на сервере.
    this.perform("appear", { appearing_on: this.appearingOn })
  },

  away() {
    // Вызывает `AppearanceChannel#away` на сервере.
    this.perform("away")
  },

  install() {
    window.addEventListener("focus", this.update)
    window.addEventListener("blur", this.update)
    document.addEventListener("turbolinks:load", this.update)
    document.addEventListener("visibilitychange", this.update)
  },

  uninstall() {
    window.removeEventListener("focus", this.update)
    window.removeEventListener("blur", this.update)
    document.removeEventListener("turbolinks:load", this.update)
    document.removeEventListener("visibilitychange", this.update)
  },

  get documentIsActive() {
    return document.visibilityState == "visible" && document.hasFocus()
  },

  get appearingOn() {
    const element = document.querySelector("[data-appearing-on]")
    return element ? element.getAttribute("data-appearing-on") : null
  }
});