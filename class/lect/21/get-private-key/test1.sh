
rm -f ./get-private-key
go build

export Key_Account=0x1d217e902Bc1deB2e75D1Ec44bcAE03A1227a126
export Key_File=./testdata/UTC--2019-04-03T02-41-09.945205084Z--1d217e902Bc1deB2e75D1Ec44bcAE03A1227a126
export Key_File_Password=BuPgWKoLOWhuue8p

./get-private-key -keyfile "${Key_File}" -password "${Key_File_Password}"

