class @WalletSendMobileValidationDialogViewController extends @DialogViewController

  view:
    spinnerContainer: '#spinner_container'

  onAfterRender: ->
    super
    @view.spinner = ledger.spinners.createLargeSpinner(@view.spinnerContainer[0])
    @_request =  ledger.m2fa.requestValidationOnAll(@params.transaction)
    @_request.onComplete (keycode, error) ->
      if error?
        @once 'dismiss', =>
          dialog = new WalletSendErrorDialogViewController(reason: error)
          dialog.show()
      else
        @once 'dismiss', =>
          dialog = new WalletSendProcessingDialogViewController transaction: @params.transaction, keycode: keycode
          dialog.show()
      @dismiss()

  onDismiss: () ->
    super
    @_request.cancel()