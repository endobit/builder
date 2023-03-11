package main

import (
	"embed"
	"errors"
	"fmt"
	"io"
	"io/fs"
	"os"
	"path"

	"github.com/spf13/cobra"
)

//go:embed rules
var rules embed.FS

func main() {
	cmd := cobra.Command{
		Use:   "builder",
		Short: "software build tools",
	}

	cmd.AddCommand(newInitCmd())

	if err := cmd.Execute(); err != nil {
		os.Exit(-1)
	}
}

func newInitCmd() *cobra.Command {
	var (
		builderDir   string
		makeFile     string
		organization string
	)

	cmd := cobra.Command{
		Use:   "init",
		Short: "initialize the build environment",
		RunE: func(cmd *cobra.Command, args []string) error {
			if err := os.MkdirAll(builderDir, os.ModePerm); err != nil {
				return err
			}

			disk, err := fs.Sub(rules, "rules")
			if err != nil {
				return err
			}

			files, err := fs.ReadDir(disk, ".")
			if err != nil {
				return err
			}

			for _, f := range files {
				err := copy(disk, f.Name(), path.Join(builderDir, f.Name()))
				if err != nil {
					return fmt.Errorf("cannot copy %q: %v", f.Name(), err)
				}

				fmt.Println(path.Join(builderDir, f.Name()))
			}

			org, err := os.Create(path.Join(builderDir, "organization.mk"))
			if err != nil {
				return err
			}

			defer org.Close()

			fmt.Fprintf(org, "ORGANIZATION=%s\n", organization)

			return makefile(makeFile, builderDir)
		},
	}

	cmd.Flags().StringVar(&builderDir, "builder", ".builder", "destination dir for build rules")
	cmd.Flags().StringVar(&makeFile, "makefile", "Makefile", "make filename")
	cmd.Flags().StringVar(&organization, "organization", "endobit", "name of ORGANIZATION")

	return &cmd
}

func makefile(filename, builderDir string) error {
	_, err := os.Stat(filename)
	if err != nil && errors.Is(err, os.ErrNotExist) {
		fout, err := os.Create(filename)
		if err != nil {
			return err
		}

		defer fout.Close()

		fmt.Fprintf(fout, "BUILDER=./%s\n", builderDir)
		fmt.Fprintf(fout, "include $(BUILDER)/rules.mk\n")
		fmt.Fprintln(fout)

		return nil
	}

	return fmt.Errorf("cannot initialize %q - file exists", filename)
}

func copy(disk fs.FS, src, dst string) error {
	fin, err := disk.Open(src)
	if err != nil {
		return err
	}

	defer fin.Close()

	fout, err := os.Create(dst)
	if err != nil {
		return err
	}

	defer fout.Close()

	_, err = io.Copy(fout, fin)

	return err
}
