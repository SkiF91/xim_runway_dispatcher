function makeFetch(action, method, callback) {
  var csrfToken = document.querySelector("[name='csrf-token']").content

  return fetch(action, {
    method: method,
    headers: {'X-CSRF-Token': csrfToken}
  })
      .then(resp => resp.ok ? resp : Promise.reject(resp))
      .then(resp => resp.json())
      .then(callback)
      .catch((err) => console.log(err))
}

export { makeFetch }