#' eWrapper for exchange_rate instruments...
#' 
#' eWrapper for exchange_rate instruments
#' 
#' This is \code{eWrapper.data} modified to exclude the Last, LastSize, and
#' Volume columns because IBrokers does not disseminate FX trade data.
#' 
#' @param n number of contracts being watched
#' @return list of functions
#' @seealso \code{eWrapper.data}
#' @export
eWrapper.FXdata <- function (n) 
{
    eW <- eWrapper(NULL)
    eW$assign.Data("data", rep(list(structure(.xts(matrix(rep(NA_real_, 
        4), ncol = 4), 0), .Dimnames = list(NULL, c("BidSize", 
        "BidPrice", "AskPrice", "AskSize")))), n))
    eW$tickPrice <- function(curMsg, msg, timestamp, file, ...) {
        tickType = msg[3]
        msg <- as.numeric(msg)
        id <- msg[2]
        data <- eW$get.Data("data")
        attr(data[[id]], "index") <- as.numeric(Sys.time())
        nr.data <- NROW(data[[id]])
        if (tickType == .twsTickType$BID) {
            data[[id]][nr.data, 1:2] <- msg[5:4]
        }
        else if (tickType == .twsTickType$ASK) {
            data[[id]][nr.data, 3:4] <- msg[4:5]
        }
#        else if (tickType == .twsTickType$LAST) {
#            data[[id]][nr.data, 5] <- msg[4]
#        }
        eW$assign.Data("data", data)
        c(curMsg, msg)
    }
    eW$tickSize <- function(curMsg, msg, timestamp, file, ...) {
        data <- eW$get.Data("data")
        tickType = msg[3]
        msg <- as.numeric(msg)
        id <- as.numeric(msg[2])
        attr(data[[id]], "index") <- as.numeric(Sys.time())
        nr.data <- NROW(data[[id]])
        if (tickType == .twsTickType$BID_SIZE) {
            data[[id]][nr.data, 1] <- msg[4]
        }
        else if (tickType == .twsTickType$ASK_SIZE) {
            data[[id]][nr.data, 4] <- msg[4]
        }
#        else if (tickType == .twsTickType$LAST_SIZE) {
#            data[[id]][nr.data, 6] <- msg[4]
#        }
#        else if (tickType == .twsTickType$VOLUME) {
#            data[[id]][nr.data, 7] <- msg[4]
#        }
        eW$assign.Data("data", data)
        c(curMsg, msg)
    }
    return(eW)
}

