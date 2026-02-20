Name:           garcon
Version:        4.20.0
Release:        1%{?dist}
Summary:        Implementation of the Freemenu Desktop Menu Specification

License:        LGPLv2+
URL:            https://www.xfce.org/
Source0:        https://archive.xfce.org/src/xfce/garcon/4.20/garcon-%{version}.tar.bz2

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  gtk3-devel
BuildRequires:  libxfce4ui-devel >= 4.20.0
BuildRequires:  libxfce4util-devel >= 4.20.0
BuildRequires:  xfce4-dev-tools
BuildRequires:  gettext
BuildRequires:  intltool

%description
Garcon is an implementation of the Freemenu Desktop Menu Specification.

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

%find_lang garcon

%files -f garcon.lang
%license COPYING
%doc AUTHORS ChangeLog NEWS
%{_libdir}/libgarcon-1.so.*
%{_libdir}/libgarcon-gtk3-1.so.*
%{_sysconfdir}/xdg/menus/xfce-applications.menu
%{_datadir}/desktop-directories/*.directory
%{_datadir}/icons/hicolor/*/apps/org.xfce.garcon.png

%files devel
%{_includedir}/garcon-1/
%{_includedir}/garcon-gtk3-1/
%{_libdir}/libgarcon-1.so
%{_libdir}/libgarcon-gtk3-1.so
%{_libdir}/pkgconfig/garcon-1.pc
%{_libdir}/pkgconfig/garcon-gtk3-1.pc

%changelog
* Tue Feb 17 2026 Anders <anders@example.com> - 4.20.0-1
- Initial release for Xfce 4.20
