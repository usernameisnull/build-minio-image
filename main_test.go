package main

import (
	"reflect"
	"testing"
)

func Test_parseDateStr(t *testing.T) {
	type args struct {
		dateStr string
	}
	tests := []struct {
		name    string
		args    args
		want    int64
		wantErr bool
	}{
		{
			name: "parse success",
			args: args{
				dateStr: "2025-09-07T04:51:50Z",
			},
			want:    1757220710,
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := parseDateStr(tt.args.dateStr)
			if (err != nil) != tt.wantErr {
				t.Errorf("parseDateStr() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("parseDateStr() got = %v, want %v", got, tt.want)
			}
		})
	}
}
