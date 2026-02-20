Name:           exo
Version:        4.20.0
Release:        1%{?dist}
Summary:        Application library for the Xfce desktop environment

License:        GPLv2+ and LGPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/exo/4.20/exo-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool
BuildRequires:  perl-URI

%description
Exo is an extension library for Xfce, developed to provide some common
functionality to the various Xfce applications.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{version}-%{release}

%description    devel
Development files for %{name}.

%prep
%autosetup

%build
%configure --disable-static
%make_build

%install
%make_install
find %{buildroot} -name '*.la' -delete

%find_lang exo

%files -f exo.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_bindir}/exo-desktop-item-edit
%{_bindir}/exo-open
%{_libdir}/libexo-2.so.*
%{_datadir}/pixmaps/exo/
%{_mandir}/man1/exo-open.1*

%files devel
%{_includedir}/exo-2/
%{_libdir}/libexo-2.so
%{_libdir}/pkgconfig/exo-2.pc

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
